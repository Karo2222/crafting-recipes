-- Idempotent synchronization for offline shopping lists and meal plans.
-- Shared editors may rename shopping lists and meal plans. Owners alone may
-- delete them or manage access; shared items and entries continue to use RLS.
begin;

create or replace function public.sync_shopping_list(
  p_id bigint,
  p_account_id bigint,
  p_name text,
  p_created_at timestamp with time zone,
  p_created_by bigint,
  p_updated_at timestamp with time zone,
  p_updated_by bigint,
  p_deleted_at timestamp with time zone default null,
  p_deleted_by bigint default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_account_id bigint := public.current_account_id();
  v_existing_owner bigint;
  v_existing_created_by bigint;
  v_existing_deleted_at timestamp with time zone;
  v_existing_deleted_by bigint;
begin
  if v_account_id is null
      or not public.current_account_can_write()
      or p_updated_by is distinct from v_account_id
      or (p_deleted_by is not null and p_deleted_by is distinct from v_account_id) then
    raise exception using errcode = '42501', message = 'shopping_list_editor_required';
  end if;
  if nullif(btrim(p_name), '') is null then
    raise exception 'shopping_list_name_required';
  end if;
  select account_id, created_by, deleted_at, deleted_by
  into v_existing_owner, v_existing_created_by,
       v_existing_deleted_at, v_existing_deleted_by
  from public.shopping_list
  where id = p_id;

  if found then
    if p_account_id is distinct from v_existing_owner
        or p_created_by is distinct from v_existing_created_by
        or not public.can_edit_shopping_list(p_id) then
      raise exception using errcode = '42501', message = 'shopping_list_editor_required';
    end if;
    if v_existing_owner is distinct from v_account_id
        and (
          p_deleted_at is distinct from v_existing_deleted_at
          or p_deleted_by is distinct from v_existing_deleted_by
        ) then
      raise exception using errcode = '42501', message = 'shopping_list_owner_required';
    end if;
    update public.shopping_list
    set name = p_name,
        updated_at = p_updated_at,
        updated_by = p_updated_by,
        deleted_at = p_deleted_at,
        deleted_by = p_deleted_by
    where id = p_id
      and updated_at < p_updated_at;
  else
    if p_account_id is distinct from v_account_id
        or p_created_by is distinct from v_account_id
        or p_deleted_at is not null
        or p_deleted_by is not null then
      raise exception using errcode = '42501', message = 'shopping_list_owner_required';
    end if;
    insert into public.shopping_list (
      id, account_id, name, created_at, created_by,
      updated_at, updated_by, deleted_at, deleted_by
    ) values (
      p_id, p_account_id, p_name, p_created_at, p_created_by,
      p_updated_at, p_updated_by, p_deleted_at, p_deleted_by
    );
  end if;
end
$$;

create or replace function public.sync_meal_plan(
  p_id bigint,
  p_account_id bigint,
  p_name text,
  p_created_at timestamp with time zone,
  p_created_by bigint,
  p_updated_at timestamp with time zone,
  p_updated_by bigint,
  p_deleted_at timestamp with time zone default null,
  p_deleted_by bigint default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_account_id bigint := public.current_account_id();
  v_existing_owner bigint;
  v_existing_created_by bigint;
  v_existing_deleted_at timestamp with time zone;
  v_existing_deleted_by bigint;
begin
  if v_account_id is null
      or not public.current_account_can_write()
      or p_updated_by is distinct from v_account_id
      or (p_deleted_by is not null and p_deleted_by is distinct from v_account_id) then
    raise exception using errcode = '42501', message = 'meal_plan_editor_required';
  end if;
  if nullif(btrim(p_name), '') is null then
    raise exception 'meal_plan_name_required';
  end if;

  select account_id, created_by, deleted_at, deleted_by
  into v_existing_owner, v_existing_created_by,
       v_existing_deleted_at, v_existing_deleted_by
  from public.meal_plan
  where id = p_id;

  if found then
    if p_account_id is distinct from v_existing_owner
        or p_created_by is distinct from v_existing_created_by
        or not public.can_edit_meal_plan(p_id) then
      raise exception using errcode = '42501', message = 'meal_plan_editor_required';
    end if;
    if v_existing_owner is distinct from v_account_id
        and (
          p_deleted_at is distinct from v_existing_deleted_at
          or p_deleted_by is distinct from v_existing_deleted_by
        ) then
      raise exception using errcode = '42501', message = 'meal_plan_owner_required';
    end if;
    update public.meal_plan
    set name = p_name,
        updated_at = p_updated_at,
        updated_by = p_updated_by,
        deleted_at = p_deleted_at,
        deleted_by = p_deleted_by
    where id = p_id
      and updated_at < p_updated_at;
  else
    if p_account_id is distinct from v_account_id
        or p_created_by is distinct from v_account_id
        or p_deleted_at is not null
        or p_deleted_by is not null then
      raise exception using errcode = '42501', message = 'meal_plan_owner_required';
    end if;
    insert into public.meal_plan (
      id, account_id, name, created_at, created_by,
      updated_at, updated_by, deleted_at, deleted_by
    ) values (
      p_id, p_account_id, p_name, p_created_at, p_created_by,
      p_updated_at, p_updated_by, p_deleted_at, p_deleted_by
    );
  end if;
end
$$;

revoke all on function public.sync_shopping_list(
  bigint, bigint, text, timestamp with time zone, bigint,
  timestamp with time zone, bigint, timestamp with time zone, bigint
) from public, anon;
revoke all on function public.sync_meal_plan(
  bigint, bigint, text, timestamp with time zone, bigint,
  timestamp with time zone, bigint, timestamp with time zone, bigint
) from public, anon;

grant execute on function public.sync_shopping_list(
  bigint, bigint, text, timestamp with time zone, bigint,
  timestamp with time zone, bigint, timestamp with time zone, bigint
) to authenticated;
grant execute on function public.sync_meal_plan(
  bigint, bigint, text, timestamp with time zone, bigint,
  timestamp with time zone, bigint, timestamp with time zone, bigint
) to authenticated;

commit;
