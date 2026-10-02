# Android Push Notifications

The Flutter and Android code is configured for Firebase project
`crafting-recipes` and Android package `com.karoline.craftingrecipes`.

Push notifications cover:

- Direct chat messages
- Friend requests
- Shopping-list invitations
- Meal-plan invitations

The implementation creates no database triggers. Notifications are queued as
separate offline mutations after the underlying message or invitation is
saved.

## 1. Create The Supabase Tables And RPCs

Open the Supabase SQL Editor for project `vooqzxwsdvgfrxvdhqrz`, paste the
complete contents of `supabase/sql/supabase_android_push_notifications.sql`, and run it.

## 2. Create A Firebase Service-Account Key

1. Open Firebase Console.
2. Open the `crafting-recipes` project.
3. Open **Project settings > Service accounts**.
4. Select **Generate new private key**.
5. Keep the downloaded JSON outside this repository.

This is a private server credential. It is different from
`android/app/google-services.json`, and it must never be committed or shared.

## 3. Install And Connect The Supabase CLI

On macOS:

```bash
brew install supabase/tap/supabase
supabase login
supabase link --project-ref vooqzxwsdvgfrxvdhqrz
```

## 4. Store The Firebase Key As A Supabase Secret

Replace the sample path with the path to the service-account JSON:

```bash
supabase secrets set FIREBASE_SERVICE_ACCOUNT_BASE64="$(base64 < /path/to/firebase-service-account.json | tr -d '\n')"
```

The Edge Function reads the key from the encrypted Supabase project secret.

## 5. Deploy The Edge Function

From the project root:

```bash
supabase functions deploy push-notification
```

JWT verification should remain enabled. Do not deploy this function with
`--no-verify-jwt`.

## 6. Install And Test

Build and install a fresh Android version:

```bash
flutter run -d YOUR_ANDROID_DEVICE_ID
```

Then:

1. Log in and allow notifications when Android asks.
2. Put that account's app in the background.
3. From another account, send a chat message or invitation.
4. Tap the notification. It should open the conversation, people screen, or
   shared-invitation inbox.

If notifications do not arrive, inspect:

- Supabase **Edge Functions > push-notification > Logs**
- Firebase **Cloud Messaging**
- `public.push_device` for a registered Android token
- `public.push_notification` for `delivered_at` or `last_error`
