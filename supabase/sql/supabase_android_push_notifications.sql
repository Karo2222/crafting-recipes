-- Android push notifications for chat messages and invitations.
-- Run this once in the Supabase SQL Editor.
-- This migration creates no database triggers.

begin;

create table if not exists public.push_device (
  id uuid primary key default gen_random_uuid(),
  account_id bigint not null
    references public.account (id) on update cascade on delete cascade,
  token text not null,
  device_id text null,
  platform text not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint push_device_token_key unique (token),
  constraint push_device_platform_check check (platform in ('android'))
);

create index if not exists push_device_account_idx
  on public.push_device (account_id);

create unique index if not exists push_device_account_installation_key
  on public.push_device (account_id, platform, device_id)
  where device_id is not null;

create table if not exists public.push_notification (
  id uuid primary key default gen_random_uuid(),
  event_key text not null unique,
  recipient_account_id bigint not null
    references public.account (id) on update cascade on delete cascade,
  actor_account_id bigint not null
    references public.account (id) on update cascade on delete cascade,
  type text not null,
  entity_id bigint null,
  created_at timestamp with time zone not null default now(),
  delivered_at timestamp with time zone null,
  last_error text null,
  constraint push_notification_type_check check (
    type in (
      'chat_message',
      'friend_request',
      'shopping_list_invitation',
      'meal_plan_invitation'
    )
  )
);

create index if not exists push_notification_recipient_created_idx
  on public.push_notification (recipient_account_id, created_at desc);

alter table public.push_device enable row level security;
alter table public.push_notification enable row level security;

revoke all on table public.push_device, public.push_notification
from public, anon, authenticated;

create or replace function public.register_push_device(
  p_token text,
  p_device_id text default null,
  p_platform text default 'android'
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_account_id bigint := public.current_account_id();
  v_now timestamp with time zone := now();
begin
  if v_account_id is null then
    raise exception using errcode = '42501', message = 'account_required';
  end if;
  if nullif(btrim(p_token), '') is null then
    raise exception 'push_token_required';
  end if;
  if p_platform <> 'android' then
    raise exception 'unsupported_push_platform';
  end if;

  delete from public.push_device
  where token = p_token
     or (
       account_id = v_account_id
       and platform = p_platform
       and p_device_id is not null
       and device_id = p_device_id
     );

  insert into public.push_device (
    account_id, token, device_id, platform, created_at, updated_at
  ) values (
    v_account_id, p_token, nullif(btrim(p_device_id), ''),
    p_platform, v_now, v_now
  );
end
$$;

create or replace function public.unregister_push_device(p_token text)
returns void
language sql
security definer
set search_path = ''
as $$
  delete from public.push_device
  where account_id = public.current_account_id()
    and token = p_token;
$$;

create or replace function public.queue_push_notification(
  p_type text,
  p_recipient_account_id bigint,
  p_entity_id bigint default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor_account_id bigint := public.current_account_id();
  v_event_key text;
  v_event_updated_at timestamp with time zone;
  v_notification_id uuid;
begin
  if v_actor_account_id is null then
    raise exception using errcode = '42501', message = 'account_required';
  end if;
  if p_recipient_account_id = v_actor_account_id then
    raise exception 'push_recipient_must_differ';
  end if;

  case p_type
    when 'chat_message' then
      select message.updated_at
      into v_event_updated_at
      from public.chat_message as message
      where message.id = p_entity_id
        and message.sender_account_id = v_actor_account_id
        and p_recipient_account_id in (
          message.first_account_id,
          message.second_account_id
        )
        and p_recipient_account_id <> message.sender_account_id
        and message.deleted_at is null;
      if not found then
        raise exception 'push_chat_message_not_available';
      end if;
      v_event_key := format('chat_message:%s', p_entity_id);

    when 'friend_request' then
      select friendship.updated_at
      into v_event_updated_at
      from public.account_friend as friendship
      where friendship.first_account_id =
          least(v_actor_account_id, p_recipient_account_id)
        and friendship.second_account_id =
          greatest(v_actor_account_id, p_recipient_account_id)
        and friendship.requested_by = v_actor_account_id
        and friendship.status = 'pending'
        and friendship.deleted_at is null;
      if not found then
        raise exception 'push_friend_request_not_available';
      end if;
      v_event_key := format(
        'friend_request:%s:%s:%s',
        v_actor_account_id,
        p_recipient_account_id,
        extract(epoch from v_event_updated_at)
      );

    when 'shopping_list_invitation' then
      select member.updated_at
      into v_event_updated_at
      from public.shopping_list_member as member
      join public.shopping_list as list
        on list.id = member.shopping_list_id
      where member.shopping_list_id = p_entity_id
        and member.account_id = p_recipient_account_id
        and member.status = 'pending'
        and member.deleted_at is null
        and list.account_id = v_actor_account_id
        and list.deleted_at is null;
      if not found then
        raise exception 'push_shopping_invitation_not_available';
      end if;
      v_event_key := format(
        'shopping_list_invitation:%s:%s:%s',
        p_entity_id,
        p_recipient_account_id,
        extract(epoch from v_event_updated_at)
      );

    when 'meal_plan_invitation' then
      select member.updated_at
      into v_event_updated_at
      from public.meal_plan_member as member
      join public.meal_plan as plan
        on plan.id = member.meal_plan_id
      where member.meal_plan_id = p_entity_id
        and member.account_id = p_recipient_account_id
        and member.status = 'pending'
        and member.deleted_at is null
        and plan.account_id = v_actor_account_id
        and plan.deleted_at is null;
      if not found then
        raise exception 'push_meal_invitation_not_available';
      end if;
      v_event_key := format(
        'meal_plan_invitation:%s:%s:%s',
        p_entity_id,
        p_recipient_account_id,
        extract(epoch from v_event_updated_at)
      );

    else
      raise exception 'unsupported_push_notification_type';
  end case;

  insert into public.push_notification (
    event_key,
    recipient_account_id,
    actor_account_id,
    type,
    entity_id
  ) values (
    v_event_key,
    p_recipient_account_id,
    v_actor_account_id,
    p_type,
    p_entity_id
  )
  on conflict (event_key) do update
  set event_key = excluded.event_key
  returning id into v_notification_id;

  return v_notification_id;
end
$$;

revoke all on function public.register_push_device(text, text, text),
  public.unregister_push_device(text),
  public.queue_push_notification(text, bigint, bigint)
from public, anon;

grant execute on function public.register_push_device(text, text, text),
  public.unregister_push_device(text),
  public.queue_push_notification(text, bigint, bigint)
to authenticated;

notify pgrst, 'reload schema';
commit;
