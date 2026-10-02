-- Preserve readable chat and meal-plan history when a recipe disappears.
-- This migration intentionally uses no triggers.
-- Run this entire file once in the Supabase SQL Editor.
begin;

alter table public.chat_message
  add column if not exists recipe_title_snapshot character varying null;
alter table public.meal_plan_entry
  add column if not exists recipe_title_snapshot character varying null;
alter table public.meal_plan_template_entry
  add column if not exists recipe_title_snapshot character varying null;

alter table public.chat_message
  drop constraint if exists chat_message_recipe_fkey;
alter table public.chat_message
  add constraint chat_message_recipe_fkey foreign key (recipe_id)
    references public.recipe (id) on update cascade on delete set null;
alter table public.meal_plan_entry
  drop constraint if exists meal_plan_entry_recipe_id_fkey;
alter table public.meal_plan_entry
  add constraint meal_plan_entry_recipe_id_fkey foreign key (recipe_id)
    references public.recipe (id) on update cascade on delete set null;
alter table public.meal_plan_template_entry
  drop constraint if exists meal_plan_template_entry_recipe_id_fkey;
alter table public.meal_plan_template_entry
  add constraint meal_plan_template_entry_recipe_id_fkey foreign key (recipe_id)
    references public.recipe (id) on update cascade on delete set null;

update public.chat_message as message
set recipe_title_snapshot = recipe.title
from public.recipe as recipe
where message.recipe_id = recipe.id
  and nullif(btrim(message.recipe_title_snapshot), '') is null;

update public.meal_plan_entry as entry
set recipe_title_snapshot = recipe.title
from public.recipe as recipe
where entry.recipe_id = recipe.id
  and nullif(btrim(entry.recipe_title_snapshot), '') is null;

update public.meal_plan_template_entry as entry
set recipe_title_snapshot = recipe.title
from public.recipe as recipe
where entry.recipe_id = recipe.id
  and nullif(btrim(entry.recipe_title_snapshot), '') is null;

alter table public.chat_message
  drop constraint if exists chat_message_content_check;
alter table public.chat_message
  add constraint chat_message_content_check check (
    nullif(btrim(message), '') is not null or
    recipe_id is not null or
    nullif(btrim(recipe_title_snapshot), '') is not null
  );

alter table public.meal_plan_entry
  drop constraint if exists meal_plan_entry_content_check;
alter table public.meal_plan_entry
  add constraint meal_plan_entry_content_check check (
    (recipe_id is not null and custom_title is null) or
    (recipe_id is null and custom_title is not null and btrim(custom_title) <> '') or
    (recipe_id is null and custom_title is null and
      nullif(btrim(recipe_title_snapshot), '') is not null)
  );

alter table public.meal_plan_template_entry
  drop constraint if exists meal_plan_template_entry_content_check;
alter table public.meal_plan_template_entry
  add constraint meal_plan_template_entry_content_check check (
    (recipe_id is not null and custom_title is null) or
    (recipe_id is null and custom_title is not null and btrim(custom_title) <> '') or
    (recipe_id is null and custom_title is null and
      nullif(btrim(recipe_title_snapshot), '') is not null)
  );

drop function if exists public.send_direct_message(
  bigint, bigint, text, bigint, timestamptz, timestamptz
);

create or replace function public.send_direct_message(
  p_friend_account_id bigint,
  p_message_id bigint,
  p_message text default null,
  p_recipe_id bigint default null,
  p_created_at timestamp with time zone default now(),
  p_updated_at timestamp with time zone default now(),
  p_recipe_title_snapshot text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
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
    and excluded.updated_at >= chat_message.updated_at;
end;
$$;

revoke all on function public.send_direct_message(
  bigint, bigint, text, bigint, timestamptz, timestamptz, text
) from public, anon;
grant execute on function public.send_direct_message(
  bigint, bigint, text, bigint, timestamptz, timestamptz, text
) to authenticated;

commit;
