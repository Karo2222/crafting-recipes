-- Direct chats between accepted friends. No triggers are used.
begin;

create table if not exists public.chat_conversation (
  first_account_id bigint not null,
  second_account_id bigint not null,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint chat_conversation_pkey
    primary key (first_account_id, second_account_id),
  constraint chat_conversation_order_check
    check (first_account_id < second_account_id),
  constraint chat_conversation_first_fkey foreign key (first_account_id)
    references public.account (id) on update cascade on delete cascade,
  constraint chat_conversation_second_fkey foreign key (second_account_id)
    references public.account (id) on update cascade on delete cascade,
  constraint chat_conversation_created_by_fkey foreign key (created_by)
    references public.account (id) on update cascade,
  constraint chat_conversation_updated_by_fkey foreign key (updated_by)
    references public.account (id) on update cascade,
  constraint chat_conversation_deleted_by_fkey foreign key (deleted_by)
    references public.account (id) on update cascade
);

create table if not exists public.chat_message (
  id bigint not null,
  first_account_id bigint not null,
  second_account_id bigint not null,
  sender_account_id bigint not null,
  message text null,
  recipe_id bigint null,
  recipe_title_snapshot character varying null,
  read_at timestamp with time zone null,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint chat_message_pkey primary key (id),
  constraint chat_message_content_check check (
    nullif(btrim(message), '') is not null or
    recipe_id is not null or
    nullif(btrim(recipe_title_snapshot), '') is not null
  ),
  constraint chat_message_conversation_fkey
    foreign key (first_account_id, second_account_id)
    references public.chat_conversation (first_account_id, second_account_id)
    on update cascade on delete cascade,
  constraint chat_message_sender_fkey foreign key (sender_account_id)
    references public.account (id) on update cascade on delete cascade,
  constraint chat_message_recipe_fkey foreign key (recipe_id)
    references public.recipe (id) on update cascade on delete set null,
  constraint chat_message_created_by_fkey foreign key (created_by)
    references public.account (id) on update cascade,
  constraint chat_message_updated_by_fkey foreign key (updated_by)
    references public.account (id) on update cascade,
  constraint chat_message_deleted_by_fkey foreign key (deleted_by)
    references public.account (id) on update cascade
);

create index if not exists chat_message_conversation_created_idx
  on public.chat_message
    (first_account_id, second_account_id, created_at, id)
  where deleted_at is null;

alter table public.chat_message
  add column if not exists read_at timestamp with time zone null;

create table if not exists public.chat_message_reaction (
  message_id bigint not null,
  account_id bigint not null,
  reaction character varying not null,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint chat_message_reaction_pkey primary key (message_id, account_id),
  constraint chat_message_reaction_value_check
    check (reaction in ('👍', '❤️', '😂', '😮', '😢', '🎉')),
  constraint chat_message_reaction_message_fkey foreign key (message_id)
    references public.chat_message (id) on update cascade on delete cascade,
  constraint chat_message_reaction_account_fkey foreign key (account_id)
    references public.account (id) on update cascade on delete cascade,
  constraint chat_message_reaction_created_by_fkey foreign key (created_by)
    references public.account (id) on update cascade,
  constraint chat_message_reaction_updated_by_fkey foreign key (updated_by)
    references public.account (id) on update cascade,
  constraint chat_message_reaction_deleted_by_fkey foreign key (deleted_by)
    references public.account (id) on update cascade
);

create or replace function public.is_chat_participant(
  p_first_account_id bigint,
  p_second_account_id bigint
)
returns boolean language sql stable security definer set search_path = '' as $$
  select public.current_account_id() in (p_first_account_id, p_second_account_id)
$$;

create or replace function public.send_direct_message(
  p_friend_account_id bigint,
  p_message_id bigint,
  p_message text default null,
  p_recipe_id bigint default null,
  p_created_at timestamp with time zone default now(),
  p_updated_at timestamp with time zone default now(),
  p_recipe_title_snapshot text default null
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
begin
  if v_account_id is null or p_friend_account_id = v_account_id then
    raise exception 'invalid_chat_recipient';
  end if;
  if not public.current_account_can_write() then
    raise exception 'chat_write_not_allowed';
  end if;
  if nullif(btrim(p_message), '') is null
    and p_recipe_id is null
    and v_recipe_title_snapshot is null then
    raise exception 'empty_chat_message';
  end if;
  v_first := least(v_account_id, p_friend_account_id);
  v_second := greatest(v_account_id, p_friend_account_id);

  if not exists (
    select 1 from public.account_friend
    where first_account_id = v_first
      and second_account_id = v_second
      and status = 'accepted'
      and deleted_at is null
  ) then
    raise exception 'accepted_friend_required';
  end if;

  if p_recipe_id is not null then
    select recipe.title into v_recipe_title_snapshot
    from public.recipe as recipe
    where recipe.id = p_recipe_id and recipe.deleted_at is null;
    if not found then
      v_recipe_id := null;
    end if;
  end if;
  if nullif(btrim(p_message), '') is null
    and v_recipe_id is null
    and v_recipe_title_snapshot is null then
    raise exception 'shared_recipe_not_found';
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
    created_at, created_by, updated_at, updated_by,
    deleted_at, deleted_by
  ) values (
    p_message_id, v_first, v_second, v_account_id,
    nullif(btrim(p_message), ''), v_recipe_id, v_recipe_title_snapshot,
    v_created_at, v_account_id, v_updated_at, v_account_id,
    null, null
  )
  on conflict (id) do update
  set message = excluded.message,
      recipe_id = excluded.recipe_id,
      recipe_title_snapshot = excluded.recipe_title_snapshot,
      updated_at = greatest(chat_message.updated_at, excluded.updated_at),
      updated_by = excluded.updated_by
  where chat_message.sender_account_id = v_account_id
    and chat_message.first_account_id = v_first
    and chat_message.second_account_id = v_second;
end
$$;

create or replace function public.set_message_reaction(
  p_message_id bigint,
  p_reaction text default null,
  p_updated_at timestamp with time zone default now()
)
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_account_id bigint := public.current_account_id();
  v_now timestamp with time zone := coalesce(p_updated_at, now());
begin
  if v_account_id is null then return; end if;
  if not public.current_account_can_write() then
    raise exception 'chat_write_not_allowed';
  end if;
  if p_reaction is not null
    and p_reaction not in ('👍', '❤️', '😂', '😮', '😢', '🎉') then
    raise exception 'invalid_message_reaction';
  end if;
  if not exists (
    select 1 from public.chat_message as message
    where message.id = p_message_id
      and message.deleted_at is null
      and v_account_id in (
        message.first_account_id,
        message.second_account_id
      )
  ) then
    raise exception 'chat_message_not_available';
  end if;

  if p_reaction is null then
    update public.chat_message_reaction
    set updated_at = v_now,
        updated_by = v_account_id,
        deleted_at = v_now,
        deleted_by = v_account_id
    where message_id = p_message_id and account_id = v_account_id;
    return;
  end if;

  insert into public.chat_message_reaction as message_reaction (
    message_id, account_id, reaction,
    created_at, created_by, updated_at, updated_by,
    deleted_at, deleted_by
  ) values (
    p_message_id, v_account_id, p_reaction,
    v_now, v_account_id, v_now, v_account_id,
    null, null
  )
  on conflict (message_id, account_id) do update
  set reaction = excluded.reaction,
      updated_at = excluded.updated_at,
      updated_by = excluded.updated_by,
      deleted_at = null,
      deleted_by = null;
end
$$;

create or replace function public.mark_chat_messages_read(
  p_friend_account_id bigint
)
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_account_id bigint := public.current_account_id();
  v_first bigint;
  v_second bigint;
  v_read_at timestamp with time zone := now();
begin
  if v_account_id is null or p_friend_account_id = v_account_id then
    raise exception 'invalid_chat_participant';
  end if;
  v_first := least(v_account_id, p_friend_account_id);
  v_second := greatest(v_account_id, p_friend_account_id);

  update public.chat_message
  set read_at = v_read_at,
      updated_at = greatest(updated_at, v_read_at),
      updated_by = v_account_id
  where first_account_id = v_first
    and second_account_id = v_second
    and sender_account_id = p_friend_account_id
    and read_at is null
    and deleted_at is null;
end
$$;

alter table public.chat_conversation enable row level security;
alter table public.chat_message enable row level security;
alter table public.chat_message_reaction enable row level security;

drop policy if exists chat_conversation_participant_read
  on public.chat_conversation;
create policy chat_conversation_participant_read
on public.chat_conversation for select to authenticated
using (public.is_chat_participant(first_account_id, second_account_id));

drop policy if exists chat_message_participant_read on public.chat_message;
create policy chat_message_participant_read
on public.chat_message for select to authenticated
using (public.is_chat_participant(first_account_id, second_account_id));

drop policy if exists chat_reaction_participant_read
  on public.chat_message_reaction;
create policy chat_reaction_participant_read
on public.chat_message_reaction for select to authenticated
using (
  exists (
    select 1 from public.chat_message as message
    where message.id = message_id
      and public.is_chat_participant(
        message.first_account_id,
        message.second_account_id
      )
  )
);

revoke all on table public.chat_conversation,
  public.chat_message, public.chat_message_reaction
from public, anon, authenticated;
grant select on table public.chat_conversation,
  public.chat_message, public.chat_message_reaction
to authenticated;

revoke all on function public.is_chat_participant(bigint, bigint),
  public.send_direct_message(bigint, bigint, text, bigint, timestamptz, timestamptz, text),
  public.set_message_reaction(bigint, text, timestamptz),
  public.mark_chat_messages_read(bigint)
from public, anon;
grant execute on function public.is_chat_participant(bigint, bigint),
  public.send_direct_message(bigint, bigint, text, bigint, timestamptz, timestamptz, text),
  public.set_message_reaction(bigint, text, timestamptz),
  public.mark_chat_messages_read(bigint)
to authenticated;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'chat_conversation', 'chat_message', 'chat_message_reaction'
  ] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = table_name
    ) then
      execute format(
        'alter publication supabase_realtime add table public.%I',
        table_name
      );
    end if;
  end loop;
end
$$;

notify pgrst, 'reload schema';
commit;
