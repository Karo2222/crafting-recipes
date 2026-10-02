import { createClient } from 'npm:@supabase/supabase-js@2'
import { JWT } from 'npm:google-auth-library@9'

type PushNotification = {
  id: string
  recipient_account_id: number
  actor_account_id: number
  type:
    | 'chat_message'
    | 'friend_request'
    | 'shopping_list_invitation'
    | 'meal_plan_invitation'
  entity_id: number | null
  delivered_at: string | null
}

type FirebaseServiceAccount = {
  project_id: string
  client_email: string
  private_key: string
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}
const jsonHeaders = {
  ...corsHeaders,
  'Content-Type': 'application/json',
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: jsonHeaders })
  }
  if (request.method !== 'POST') {
    return response({ error: 'method_not_allowed' }, 405)
  }

  try {
    const authorization = request.headers.get('Authorization')
    const accessToken = authorization?.replace(/^Bearer\s+/i, '')
    if (!accessToken) return response({ error: 'authentication_required' }, 401)

    const supabaseUrl = requiredEnvironment('SUPABASE_URL')
    const serviceRoleKey = requiredEnvironment('SUPABASE_SERVICE_ROLE_KEY')
    const service = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    })
    const {
      data: { user },
      error: userError,
    } = await service.auth.getUser(accessToken)
    if (userError || !user) {
      return response({ error: 'invalid_session' }, 401)
    }

    const payload = await request.json()
    const notificationId = payload?.notification_id?.toString()
    if (!notificationId) {
      return response({ error: 'notification_id_required' }, 400)
    }

    const { data: actor, error: actorError } = await service
      .from('account')
      .select('id, account_name, profile_image')
      .eq('auth_user_id', user.id)
      .is('deleted_at', null)
      .single()
    if (actorError || !actor) {
      return response({ error: 'linked_account_required' }, 403)
    }

    const { data: notification, error: notificationError } = await service
      .from('push_notification')
      .select(
        'id, recipient_account_id, actor_account_id, type, entity_id, delivered_at',
      )
      .eq('id', notificationId)
      .single<PushNotification>()
    if (notificationError || !notification) {
      return response({ error: 'notification_not_found' }, 404)
    }
    if (notification.actor_account_id !== actor.id) {
      return response({ error: 'notification_actor_mismatch' }, 403)
    }
    if (notification.delivered_at) {
      return response({ delivered: true, duplicate: true })
    }

    const [{ data: targetDevices, error: devicesError }, language] =
      await Promise.all([
        service
          .from('push_device')
          .select('id, token')
          .eq('account_id', notification.recipient_account_id),
        recipientLanguage(service, notification.recipient_account_id),
      ])
    if (devicesError) throw devicesError

    const content = await notificationContent(
      service,
      notification,
      actor.account_name,
      language,
    )
    if (!targetDevices || targetDevices.length === 0) {
      await markDelivered(service, notification.id)
      return response({ delivered: true, devices: 0 })
    }

    const serviceAccount = firebaseServiceAccount()
    const firebaseAccessToken = await getFirebaseAccessToken(serviceAccount)
    const failures: string[] = []
    let deliveredDevices = 0

    for (const device of targetDevices) {
      const result = await sendFirebaseMessage({
        serviceAccount,
        firebaseAccessToken,
        token: device.token,
        notification,
        actorName: actor.account_name,
        actorProfileImage: actor.profile_image,
        language,
        title: content.title,
        body: content.body,
      })
      if (result.ok) {
        deliveredDevices += 1
        continue
      }
      if (result.invalidToken) {
        await service.from('push_device').delete().eq('id', device.id)
        continue
      }
      failures.push(result.error)
    }

    if (failures.length > 0) {
      const errorText = failures.join(' | ').slice(0, 1000)
      await service
        .from('push_notification')
        .update({ last_error: errorText })
        .eq('id', notification.id)
      return response({ error: 'firebase_delivery_failed', details: failures }, 502)
    }

    await markDelivered(service, notification.id)
    return response({
      delivered: true,
      devices: deliveredDevices,
    })
  } catch (error) {
    console.error(error)
    return response(
      {
        error: 'push_notification_failed',
        details: error instanceof Error ? error.message : String(error),
      },
      500,
    )
  }
})

async function recipientLanguage(
  service: ReturnType<typeof createClient>,
  accountId: number,
): Promise<string> {
  const { data, error } = await service
    .from('setting')
    .select('language')
    .eq('account_id', accountId)
    .maybeSingle()
  if (error) {
    console.warn('Could not load notification language', error)
    return 'en'
  }
  return data?.language === 'de' ? 'de' : 'en'
}

async function notificationContent(
  service: ReturnType<typeof createClient>,
  notification: PushNotification,
  actorName: string,
  language: string,
): Promise<{ title: string; body: string }> {
  const german = language === 'de'
  switch (notification.type) {
    case 'chat_message': {
      const { data: message } = await service
        .from('chat_message')
        .select(
          'message, recipe_title_snapshot, shopping_list_name_snapshot',
        )
        .eq('id', notification.entity_id)
        .maybeSingle()
      const text = message?.message?.trim()
      const recipeTitle = message?.recipe_title_snapshot?.trim()
      const shoppingListName =
        message?.shopping_list_name_snapshot?.trim()
      let body: string
      if (text) {
        body = truncate(text, 140)
      } else if (recipeTitle) {
        body = german
          ? `Hat das Rezept „${recipeTitle}“ geteilt`
          : `Shared the recipe "${recipeTitle}"`
      } else if (shoppingListName) {
        body = german
          ? `Hat die Einkaufsliste „${shoppingListName}“ geteilt`
          : `Shared the shopping list "${shoppingListName}"`
      } else {
        body = german
          ? 'Hat dir eine Nachricht gesendet'
          : 'Sent you a message'
      }
      return { title: actorName, body }
    }
    case 'friend_request':
      return {
        title: german ? 'Freundschaftsanfrage' : 'Friend request',
        body: german
          ? `${actorName} möchte dich als Freund hinzufügen.`
          : `${actorName} wants to add you as a friend.`,
      }
    case 'shopping_list_invitation': {
      const name = await getResourceName(
        service,
        'shopping_list',
        notification.entity_id,
      )
      return {
        title: german
          ? 'Einladung zur Einkaufsliste'
          : 'Shopping-list invitation',
        body: german
          ? `${actorName} hat dich zu „${name}“ eingeladen.`
          : `${actorName} invited you to "${name}".`,
      }
    }
    case 'meal_plan_invitation': {
      const name = await getResourceName(
        service,
        'meal_plan',
        notification.entity_id,
      )
      return {
        title: german ? 'Einladung zum Essensplan' : 'Meal-plan invitation',
        body: german
          ? `${actorName} hat dich zu „${name}“ eingeladen.`
          : `${actorName} invited you to "${name}".`,
      }
    }
  }
}

async function getResourceName(
  service: ReturnType<typeof createClient>,
  table: 'shopping_list' | 'meal_plan',
  id: number | null,
): Promise<string> {
  if (id == null) return table === 'shopping_list' ? 'Shopping list' : 'Meal plan'
  const { data } = await service.from(table).select('name').eq('id', id).maybeSingle()
  return data?.name?.trim() || (table === 'shopping_list' ? 'Shopping list' : 'Meal plan')
}

async function markDelivered(
  service: ReturnType<typeof createClient>,
  notificationId: string,
) {
  const { error } = await service
    .from('push_notification')
    .update({
      delivered_at: new Date().toISOString(),
      last_error: null,
    })
    .eq('id', notificationId)
  if (error) throw error
}

async function sendFirebaseMessage({
  serviceAccount,
  firebaseAccessToken,
  token,
  notification,
  actorName,
  actorProfileImage,
  language,
  title,
  body,
}: {
  serviceAccount: FirebaseServiceAccount
  firebaseAccessToken: string
  token: string
  notification: PushNotification
  actorName: string
  actorProfileImage: string | null
  language: string
  title: string
  body: string
}): Promise<{ ok: boolean; invalidToken: boolean; error: string }> {
  const firebaseResponse = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${firebaseAccessToken}`,
      },
      body: JSON.stringify({
        message: {
          token,
          data: {
            type: notification.type,
            actor_account_id: notification.actor_account_id.toString(),
            actor_name: actorName,
            actor_profile_image: actorProfileImage?.trim() ?? '',
            entity_id: notification.entity_id?.toString() ?? '',
            notification_id: notification.id,
            sent_at: new Date().toISOString(),
            title,
            body,
            group_body:
              language === 'de'
                ? 'Neue Benachrichtigungen'
                : 'New notifications',
          },
          android: {
            priority: 'high',
          },
        },
      }),
    },
  )
  if (firebaseResponse.ok) {
    return { ok: true, invalidToken: false, error: '' }
  }

  const errorBody = await firebaseResponse.text()
  const invalidToken =
    firebaseResponse.status === 404 ||
    errorBody.includes('UNREGISTERED') ||
    errorBody.includes('registration-token-not-registered')
  return {
    ok: false,
    invalidToken,
    error: `${firebaseResponse.status}: ${errorBody}`,
  }
}

function firebaseServiceAccount(): FirebaseServiceAccount {
  const encoded = requiredEnvironment('FIREBASE_SERVICE_ACCOUNT_BASE64')
  const decoded = Uint8Array.from(atob(encoded), (character) =>
    character.charCodeAt(0),
  )
  const account = JSON.parse(new TextDecoder().decode(decoded))
  return {
    project_id: account.project_id,
    client_email: account.client_email,
    private_key: account.private_key,
  }
}

function getFirebaseAccessToken(
  serviceAccount: FirebaseServiceAccount,
): Promise<string> {
  return new Promise((resolve, reject) => {
    const client = new JWT({
      email: serviceAccount.client_email,
      key: serviceAccount.private_key,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    client.authorize((error, tokens) => {
      if (error) {
        reject(error)
        return
      }
      if (!tokens?.access_token) {
        reject(new Error('firebase_access_token_missing'))
        return
      }
      resolve(tokens.access_token)
    })
  })
}

function requiredEnvironment(name: string): string {
  const value = Deno.env.get(name)
  if (!value) throw new Error(`${name}_missing`)
  return value
}

function truncate(value: string, maxLength: number): string {
  return value.length <= maxLength
    ? value
    : `${value.slice(0, maxLength - 1)}…`
}

function response(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: jsonHeaders,
  })
}
