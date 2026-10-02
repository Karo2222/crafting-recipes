-- Chat replies and access-aware shopping-list sharing. No triggers are used.
begin;

alter table public.chat_message
  add column if not exists shopping_list_id bigint null,
  add column if not exists shopping_list_name_snapshot character varying null,
  add column if not exists reply_to_message_id bigint null,
  add column if not exists reply_message_snapshot text null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'chat_message_shopping_list_fkey'
      and conrelid = 'public.chat_message'::regclass
  ) then
    alter table public.chat_message
      add constraint chat_message_shopping_list_fkey
      foreign key (shopping_list_id)
      references public.shopping_list (id)
      on update cascade on delete set null;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'chat_message_reply_fkey'
      and conrelid = 'public.chat_message'::regclass
  ) then
    alter table public.chat_message
      add constraint chat_message_reply_fkey
      foreign key (reply_to_message_id)
      references public.chat_message (id)
      on update cascade on delete set null;
  end if;
end
$$;

alter table public.chat_message
  drop constraint if exists chat_message_content_check;
alter table public.chat_message
  add constraint chat_message_content_check check (
    nullif(btrim(message), '') is not null or
    recipe_id is not null or
    nullif(btrim(recipe_title_snapshot), '') is not null or
    shopping_list_id is not null or
    nullif(btrim(shopping_list_name_snapshot), '') is not null
  );

create index if not exists chat_message_shopping_list_idx
  on public.chat_message (shopping_list_id)
  where shopping_list_id is not null;

create index if not exists chat_message_reply_idx
  on public.chat_message (reply_to_message_id)
  where reply_to_message_id is not null;

drop function if exists public.send_direct_message(
  bigint, bigint, text, bigint, timestamp with time zone,
  timestamp with time zone, text
);
drop function if exists public.send_direct_message(
  bigint, bigint, text, bigint, timestamp with time zone,
  timestamp with time zone, text, bigint, text, bigint, text
);

create function public.send_direct_message(
  p_friend_account_id bigint,
  p_message_id bigint,
  p_message text default null,
  p_recipe_id bigint default null,
  p_created_at timestamp with time zone default now(),
  p_updated_at timestamp with time zone default now(),
  p_recipe_title_snapshot text default null,
  p_shopping_list_id bigint default null,
  p_shopping_list_name_snapshot text default null,
  p_reply_to_message_id bigint default null,
  p_reply_message_snapshot text default null
)
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_account_id bigint := public.current_account_id();
  v_first bigint;
  v_second bigint;
  v_created_at timestamp with time zone := coalesce(p_created_at, now());
  v_updated_at timestamp with time zone := coalesce(p_updated_at, now());
  v_recipe_id bigint := p_recipe_id;
  v_recipe_title_snapshot text := nullif(btrim(p_recipe_title_snapshot), '');
  v_shopping_list_id bigint := p_shopping_list_id;
  v_shopping_list_name_snapshot text;
  v_reply_to_message_id bigint := p_reply_to_message_id;
  v_reply_message_snapshot text;
begin
  if v_account_id is null or p_friend_account_id = v_account_id then
    raise exception 'invalid_chat_recipient';
  end if;
  if not public.current_account_can_write() then
    raise exception 'chat_write_not_allowed';
  end if;

  v_first := least(v_account_id, p_friend_account_id);
  v_second := greatest(v_account_id, p_friend_account_id);

  if not exists (
    select 1
    from public.account_friend
    where first_account_id = v_first
      and second_account_id = v_second
      and status = 'accepted'
      and deleted_at is null
  ) then
    raise exception 'accepted_friend_required';
  end if;

  if p_recipe_id is not null then
    select recipe.title
    into v_recipe_title_snapshot
    from public.recipe as recipe
    where recipe.id = p_recipe_id
      and recipe.deleted_at is null;
    if not found then
      v_recipe_id := null;
    end if;
  end if;

  if p_shopping_list_id is not null then
    select shopping_list.name
    into v_shopping_list_name_snapshot
    from public.shopping_list as shopping_list
    where shopping_list.id = p_shopping_list_id
      and shopping_list.deleted_at is null
      and (
        shopping_list.account_id = v_account_id or
        exists (
          select 1
          from public.shopping_list_member as sender_member
          where sender_member.shopping_list_id = shopping_list.id
            and sender_member.account_id = v_account_id
            and sender_member.status = 'accepted'
            and sender_member.deleted_at is null
        )
      )
      and (
        shopping_list.account_id = p_friend_account_id or
        exists (
          select 1
          from public.shopping_list_member as recipient_member
          where recipient_member.shopping_list_id = shopping_list.id
            and recipient_member.account_id = p_friend_account_id
            and recipient_member.status = 'accepted'
            and recipient_member.deleted_at is null
        )
      );
    if not found then
      raise exception 'shopping_list_not_shared_with_recipient';
    end if;
  end if;

  if p_reply_to_message_id is not null then
    select coalesce(
      nullif(btrim(reply.message), ''),
      nullif(btrim(reply.recipe_title_snapshot), ''),
      nullif(btrim(reply.shopping_list_name_snapshot), '')
    )
    into v_reply_message_snapshot
    from public.chat_message as reply
    where reply.id = p_reply_to_message_id
      and reply.first_account_id = v_first
      and reply.second_account_id = v_second
      and reply.deleted_at is null;
    if not found then
      raise exception 'reply_message_not_available';
    end if;
  end if;

  if nullif(btrim(p_message), '') is null
    and v_recipe_id is null
    and v_recipe_title_snapshot is null
    and v_shopping_list_id is null then
    raise exception 'empty_chat_message';
  end if;

  insert into public.chat_conversation as conversation (
    first_account_id, second_account_id,
    created_at, created_by, updated_at, updated_by,
    deleted_at, deleted_by
  ) values (
    v_first, v_second,
    v_created_at, v_account_id, v_updated_at, v_account_id,
    null, null
  )
  on conflict (first_account_id, second_account_id) do update
  set updated_at = greatest(conversation.updated_at, excluded.updated_at),
      updated_by = excluded.updated_by,
      deleted_at = null,
      deleted_by = null;

  insert into public.chat_message as chat_message (
    id, first_account_id, second_account_id, sender_account_id,
    message, recipe_id, recipe_title_snapshot,
    shopping_list_id, shopping_list_name_snapshot,
    reply_to_message_id, reply_message_snapshot,
    created_at, created_by, updated_at, updated_by,
    deleted_at, deleted_by
  ) values (
    p_message_id, v_first, v_second, v_account_id,
    nullif(btrim(p_message), ''), v_recipe_id, v_recipe_title_snapshot,
    v_shopping_list_id, v_shopping_list_name_snapshot,
    v_reply_to_message_id, v_reply_message_snapshot,
    v_created_at, v_account_id, v_updated_at, v_account_id,
    null, null
  )
  on conflict (id) do update
  set message = excluded.message,
      recipe_id = excluded.recipe_id,
      recipe_title_snapshot = excluded.recipe_title_snapshot,
      shopping_list_id = excluded.shopping_list_id,
      shopping_list_name_snapshot = excluded.shopping_list_name_snapshot,
      reply_to_message_id = excluded.reply_to_message_id,
      reply_message_snapshot = excluded.reply_message_snapshot,
      updated_at = greatest(chat_message.updated_at, excluded.updated_at),
      updated_by = excluded.updated_by
  where chat_message.sender_account_id = v_account_id
    and chat_message.first_account_id = v_first
    and chat_message.second_account_id = v_second;
end
$$;

revoke all on function public.send_direct_message(
  bigint, bigint, text, bigint, timestamp with time zone,
  timestamp with time zone, text, bigint, text, bigint, text
) from public, anon;
grant execute on function public.send_direct_message(
  bigint, bigint, text, bigint, timestamp with time zone,
  timestamp with time zone, text, bigint, text, bigint, text
) to authenticated;

notify pgrst, 'reload schema';
commit;
