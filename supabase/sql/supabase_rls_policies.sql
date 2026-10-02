-- Crafting Recipes: authenticated Row Level Security foundation.
--
-- Run this only after supabase_auth_foundation.sql. The migration is designed
-- to be rerunnable and does not use account/profile creation triggers.
-- New public account records are created after email confirmation by the
-- complete_account_registration() function below.

begin;

-- Account names are login-adjacent identifiers and should be unique without
-- depending on capitalization or surrounding whitespace.
create unique index if not exists account_active_name_ci_key
  on public.account (lower(btrim(account_name)))
  where deleted_at is null;

-- current_account_id() is initially created by supabase_auth_foundation.sql.
-- Recreate it here so this migration remains self-contained when rerun.
create or replace function public.current_account_id()
returns bigint
language sql
stable
security definer
set search_path = ''
as $$
  select app_account.id
  from public.account as app_account
  where app_account.auth_user_id = (select auth.uid())
    and app_account.deleted_at is null
  limit 1
$$;

create or replace function public.current_account_role()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select lower(app_role.name)
  from public.account as app_account
  join public.roles as app_role on app_role.id = app_account.role_id
  where app_account.id = public.current_account_id()
    and app_account.deleted_at is null
    and app_role.deleted_at is null
  limit 1
$$;

create or replace function public.current_account_can_write()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(public.current_account_role() in ('editor', 'admin'), false)
$$;

create or replace function public.current_account_is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(public.current_account_role() = 'admin', false)
$$;

create or replace function public.can_edit_account_owned(p_owner_id bigint)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select case public.current_account_role()
    when 'admin' then true
    when 'editor' then p_owner_id = public.current_account_id()
    else false
  end
$$;

create or replace function public.can_edit_recipe(p_recipe_id bigint)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select case public.current_account_role()
    when 'admin' then exists (
      select 1 from public.recipe where id = p_recipe_id
    )
    when 'editor' then exists (
      select 1
      from public.recipe
      where id = p_recipe_id
        and created_by = public.current_account_id()
    )
    else false
  end
$$;

create or replace function public.owns_profile(p_profile_id bigint)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles
    where id = p_profile_id
      and account_id = public.current_account_id()
      and deleted_at is null
  )
$$;

create or replace function public.owns_shopping_list(p_shopping_list_id bigint)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.shopping_list
    where id = p_shopping_list_id
      and account_id = public.current_account_id()
      and deleted_at is null
  )
$$;

-- These two narrow checks replace anonymous SELECT access to host_codes and
-- account. They reveal only a boolean and never return a host code or email.
create or replace function public.validate_host_code(p_code text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.host_codes
    where code = btrim(p_code)
      and active = true
      and deleted_at is null
  )
$$;

create or replace function public.account_name_is_available(
  p_account_name text
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select btrim(coalesce(p_account_name, '')) <> ''
    and not exists (
      select 1
      from public.account
      where lower(btrim(account_name)) = lower(btrim(p_account_name))
        and deleted_at is null
    )
$$;

-- Email-confirmed users call this once on their first successful login. It
-- creates account, main profile, and settings in one transaction without a
-- trigger. The email always comes from auth.users, never client metadata.
create or replace function public.complete_account_registration()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_auth_user auth.users%rowtype;
  v_account_name text;
  v_host_code text;
  v_editor_role_id bigint;
  v_account_id bigint;
  v_profile_id bigint;
begin
  if auth.uid() is null then
    raise exception 'Authentication is required.' using errcode = '42501';
  end if;

  select *
  into v_auth_user
  from auth.users
  where id = auth.uid()
    and email_confirmed_at is not null;

  if not found then
    raise exception 'Confirm the email address before continuing.'
      using errcode = '42501';
  end if;

  select id
  into v_account_id
  from public.account
  where auth_user_id = auth.uid()
    and deleted_at is null
  limit 1;

  select id
  into v_editor_role_id
  from public.roles
  where lower(name) = 'editor'
    and deleted_at is null
  limit 1;

  if v_editor_role_id is null then
    raise exception 'The editor role is missing.';
  end if;

  if v_account_id is null then
    v_account_name := btrim(
      coalesce(v_auth_user.raw_user_meta_data ->> 'account_name', '')
    );
    v_host_code := btrim(
      coalesce(v_auth_user.raw_user_meta_data ->> 'host_code', '')
    );

    if v_account_name = '' then
      raise exception 'The account name is missing.';
    end if;

    if not public.account_name_is_available(v_account_name) then
      raise exception 'The account name is already in use.'
        using errcode = '23505';
    end if;

    if not public.validate_host_code(v_host_code) then
      raise exception 'The host code is invalid.' using errcode = '22023';
    end if;

    insert into public.account (
      account_name,
      email,
      role_id,
      host_code,
      auth_user_id
    ) values (
      v_account_name,
      v_auth_user.email,
      v_editor_role_id,
      v_host_code,
      auth.uid()
    )
    returning id into v_account_id;

    update public.account
    set created_by = v_account_id,
        updated_by = v_account_id
    where id = v_account_id;
  end if;

  select id
  into v_profile_id
  from public.profiles
  where account_id = v_account_id
    and lower(name) = 'main'
    and deleted_at is null
  limit 1;

  if v_profile_id is null then
    insert into public.profiles (
      account_id,
      name,
      role_id,
      created_by,
      updated_by
    ) values (
      v_account_id,
      'main',
      v_editor_role_id,
      v_account_id,
      v_account_id
    )
    returning id into v_profile_id;
  end if;

  insert into public.setting (
    account_id,
    language,
    realtime,
    lightmode,
    created_by,
    updated_by
  ) values (
    v_account_id,
    'en',
    true,
    true,
    v_account_id,
    v_account_id
  )
  on conflict (account_id) do nothing;

  return jsonb_build_object(
    'account_id', v_account_id,
    'profile_id', v_profile_id
  );
end
$$;

revoke all on function public.current_account_id() from public, anon;
revoke all on function public.current_account_role() from public, anon;
revoke all on function public.current_account_can_write() from public, anon;
revoke all on function public.current_account_is_admin() from public, anon;
revoke all on function public.can_edit_account_owned(bigint) from public, anon;
revoke all on function public.can_edit_recipe(bigint) from public, anon;
revoke all on function public.owns_profile(bigint) from public, anon;
revoke all on function public.owns_shopping_list(bigint) from public, anon;
revoke all on function public.validate_host_code(text) from public;
revoke all on function public.account_name_is_available(text) from public;
revoke all on function public.complete_account_registration() from public, anon;

grant execute on function public.current_account_id() to authenticated;
grant execute on function public.current_account_role() to authenticated;
grant execute on function public.current_account_can_write() to authenticated;
grant execute on function public.current_account_is_admin() to authenticated;
grant execute on function public.can_edit_account_owned(bigint) to authenticated;
grant execute on function public.can_edit_recipe(bigint) to authenticated;
grant execute on function public.owns_profile(bigint) to authenticated;
grant execute on function public.owns_shopping_list(bigint) to authenticated;
grant execute on function public.validate_host_code(text) to anon, authenticated;
grant execute on function public.account_name_is_available(text)
  to anon, authenticated;
grant execute on function public.complete_account_registration()
  to authenticated;

-- Recipe RPCs must execute as the signed-in caller so the policies below
-- remain authoritative even if a client supplies a different account ID.
do $$
declare
  v_function record;
begin
  for v_function in
    select app_function.oid::regprocedure as signature
    from pg_proc as app_function
    join pg_namespace as app_schema
      on app_schema.oid = app_function.pronamespace
    where app_schema.nspname = 'public'
      and app_function.proname in (
        'create_recipe_with_details',
        'update_recipe_with_details',
        'update_recipe_with_details_if_unchanged'
      )
  loop
    execute format('alter function %s security invoker', v_function.signature);
    execute format(
      'revoke all on function %s from public, anon',
      v_function.signature
    );
    execute format(
      'grant execute on function %s to authenticated',
      v_function.signature
    );
  end loop;
end
$$;

-- Remove anonymous table access. Supabase Auth itself is unaffected because
-- auth.users is not in the public schema.
revoke all on table
  public.account,
  public.account_follow,
  public.category,
  public.comment,
  public.device,
  public.history,
  public.host_codes,
  public.ingredient,
  public.meal_plan,
  public.meal_plan_entry,
  public.meal_plan_member,
  public.profiles,
  public.recipe,
  public.recipe_category,
  public.recipe_ingredient,
  public.recipe_like,
  public.recipe_step,
  public.recipe_step_ingredient,
  public.roles,
  public.setting,
  public.shopping_category,
  public.shopping_list,
  public.shopping_list_item,
  public.shopping_list_member,
  public.unit
from anon;

-- Direct account-table reads are restricted to the authenticated user's own
-- row by RLS below. Public discovery uses get_public_accounts() instead.
revoke all on table public.account from authenticated;
grant select on table public.account to authenticated;
grant update (
  account_name,
  profile_image,
  bio,
  updated_at,
  updated_by,
  deleted_at,
  deleted_by
) on public.account to authenticated;

grant select on table
  public.account_follow,
  public.category,
  public.comment,
  public.device,
  public.history,
  public.ingredient,
  public.meal_plan,
  public.meal_plan_entry,
  public.meal_plan_member,
  public.profiles,
  public.recipe,
  public.recipe_category,
  public.recipe_ingredient,
  public.recipe_like,
  public.recipe_step,
  public.recipe_step_ingredient,
  public.roles,
  public.setting,
  public.shopping_category,
  public.shopping_list,
  public.shopping_list_item,
  public.shopping_list_member,
  public.unit
to authenticated;

grant insert, update, delete on table
  public.account_follow,
  public.category,
  public.comment,
  public.device,
  public.history,
  public.ingredient,
  public.meal_plan,
  public.meal_plan_entry,
  public.meal_plan_member,
  public.profiles,
  public.recipe,
  public.recipe_category,
  public.recipe_ingredient,
  public.recipe_like,
  public.recipe_step,
  public.recipe_step_ingredient,
  public.roles,
  public.setting,
  public.shopping_category,
  public.shopping_list,
  public.shopping_list_item,
  public.shopping_list_member,
  public.unit
to authenticated;

grant usage, select on all sequences in schema public to authenticated;

alter table public.account enable row level security;
alter table public.account_follow enable row level security;
alter table public.category enable row level security;
alter table public.comment enable row level security;
alter table public.device enable row level security;
alter table public.history enable row level security;
alter table public.host_codes enable row level security;
alter table public.ingredient enable row level security;
alter table public.meal_plan enable row level security;
alter table public.meal_plan_entry enable row level security;
alter table public.meal_plan_member enable row level security;
alter table public.profiles enable row level security;
alter table public.recipe enable row level security;
alter table public.recipe_category enable row level security;
alter table public.recipe_ingredient enable row level security;
alter table public.recipe_like enable row level security;
alter table public.recipe_step enable row level security;
alter table public.recipe_step_ingredient enable row level security;
alter table public.roles enable row level security;
alter table public.setting enable row level security;
alter table public.shopping_category enable row level security;
alter table public.shopping_list enable row level security;
alter table public.shopping_list_item enable row level security;
alter table public.shopping_list_member enable row level security;
alter table public.unit enable row level security;

-- A direct account query can only return the logged-in account. This makes a
-- full-row Realtime subscription safe while keeping private columns private.
drop policy if exists account_read_authenticated on public.account;
create policy account_read_authenticated
on public.account for select to authenticated
using (id = public.current_account_id());

-- Account discovery deliberately exposes only public profile fields through
-- an authenticated RPC. Private columns such as email, host_code, and
-- auth_user_id are not part of its return type.
drop view if exists public.account_public;
drop function if exists public.get_public_accounts();
create function public.get_public_accounts()
returns table (
  id bigint,
  account_name text,
  profile_image text,
  bio text,
  role_id bigint,
  created_at timestamp with time zone,
  created_by bigint,
  updated_at timestamp with time zone,
  updated_by bigint,
  deleted_at timestamp with time zone,
  deleted_by bigint
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    account.id,
    account.account_name::text,
    account.profile_image::text,
    account.bio::text,
    account.role_id,
    account.created_at,
    account.created_by,
    account.updated_at,
    account.updated_by,
    account.deleted_at,
    account.deleted_by
  from public.account as account
  where public.current_account_id() is not null
  order by account.id
$$;

revoke all on function public.get_public_accounts() from public, anon;
grant execute on function public.get_public_accounts() to authenticated;

drop policy if exists account_update_self on public.account;
create policy account_update_self
on public.account for update to authenticated
using (id = public.current_account_id())
with check (
  id = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists roles_read_authenticated on public.roles;
create policy roles_read_authenticated
on public.roles for select to authenticated
using (true);

drop policy if exists roles_admin_write on public.roles;
create policy roles_admin_write
on public.roles for all to authenticated
using (public.current_account_is_admin())
with check (public.current_account_is_admin());

drop policy if exists profiles_read_own on public.profiles;
create policy profiles_read_own
on public.profiles for select to authenticated
using (account_id = public.current_account_id());

drop policy if exists profiles_admin_manage_own on public.profiles;
create policy profiles_admin_manage_own
on public.profiles for all to authenticated
using (
  account_id = public.current_account_id()
  and public.current_account_is_admin()
)
with check (
  account_id = public.current_account_id()
  and public.current_account_is_admin()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

-- Shared recipe/reference data.
drop policy if exists recipe_read_authenticated on public.recipe;
create policy recipe_read_authenticated
on public.recipe for select to authenticated
using (true);

drop policy if exists recipe_insert_editor on public.recipe;
create policy recipe_insert_editor
on public.recipe for insert to authenticated
with check (
  public.current_account_can_write()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists recipe_update_owner_or_admin on public.recipe;
create policy recipe_update_owner_or_admin
on public.recipe for update to authenticated
using (public.can_edit_account_owned(created_by))
with check (
  public.can_edit_account_owned(created_by)
  and updated_by = public.current_account_id()
);

drop policy if exists recipe_delete_owner_or_admin on public.recipe;
create policy recipe_delete_owner_or_admin
on public.recipe for delete to authenticated
using (public.can_edit_account_owned(created_by));

drop policy if exists category_read_authenticated on public.category;
create policy category_read_authenticated
on public.category for select to authenticated using (true);
drop policy if exists category_admin_write on public.category;
create policy category_admin_write
on public.category for all to authenticated
using (public.current_account_is_admin())
with check (public.current_account_is_admin());

drop policy if exists unit_read_authenticated on public.unit;
create policy unit_read_authenticated
on public.unit for select to authenticated using (true);
drop policy if exists unit_admin_write on public.unit;
create policy unit_admin_write
on public.unit for all to authenticated
using (public.current_account_is_admin())
with check (public.current_account_is_admin());

drop policy if exists shopping_category_read_authenticated
  on public.shopping_category;
create policy shopping_category_read_authenticated
on public.shopping_category for select to authenticated using (true);
drop policy if exists shopping_category_admin_write
  on public.shopping_category;
create policy shopping_category_admin_write
on public.shopping_category for all to authenticated
using (public.current_account_is_admin())
with check (public.current_account_is_admin());

drop policy if exists ingredient_read_authenticated on public.ingredient;
create policy ingredient_read_authenticated
on public.ingredient for select to authenticated using (true);
drop policy if exists ingredient_editor_insert on public.ingredient;
create policy ingredient_editor_insert
on public.ingredient for insert to authenticated
with check (
  public.current_account_can_write()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);
drop policy if exists ingredient_editor_update on public.ingredient;
create policy ingredient_editor_update
on public.ingredient for update to authenticated
using (public.current_account_can_write())
with check (
  public.current_account_can_write()
  and updated_by = public.current_account_id()
);
drop policy if exists ingredient_admin_delete on public.ingredient;
create policy ingredient_admin_delete
on public.ingredient for delete to authenticated
using (public.current_account_is_admin());

-- Recipe child tables inherit write access from their parent recipe.
drop policy if exists recipe_step_read_authenticated on public.recipe_step;
create policy recipe_step_read_authenticated
on public.recipe_step for select to authenticated using (true);
drop policy if exists recipe_step_write_parent on public.recipe_step;
create policy recipe_step_write_parent
on public.recipe_step for all to authenticated
using (public.can_edit_recipe(recipe_id))
with check (
  public.can_edit_recipe(recipe_id)
  and updated_by = public.current_account_id()
);

drop policy if exists recipe_ingredient_read_authenticated
  on public.recipe_ingredient;
create policy recipe_ingredient_read_authenticated
on public.recipe_ingredient for select to authenticated using (true);
drop policy if exists recipe_ingredient_write_parent
  on public.recipe_ingredient;
create policy recipe_ingredient_write_parent
on public.recipe_ingredient for all to authenticated
using (public.can_edit_recipe(recipe_id))
with check (
  public.can_edit_recipe(recipe_id)
  and updated_by = public.current_account_id()
);

drop policy if exists recipe_category_read_authenticated
  on public.recipe_category;
create policy recipe_category_read_authenticated
on public.recipe_category for select to authenticated using (true);
drop policy if exists recipe_category_write_parent
  on public.recipe_category;
create policy recipe_category_write_parent
on public.recipe_category for all to authenticated
using (public.can_edit_recipe(recipe_id))
with check (
  public.can_edit_recipe(recipe_id)
  and updated_by = public.current_account_id()
);

drop policy if exists recipe_step_ingredient_read_authenticated
  on public.recipe_step_ingredient;
create policy recipe_step_ingredient_read_authenticated
on public.recipe_step_ingredient for select to authenticated using (true);
drop policy if exists recipe_step_ingredient_write_parent
  on public.recipe_step_ingredient;
create policy recipe_step_ingredient_write_parent
on public.recipe_step_ingredient for all to authenticated
using (
  exists (
    select 1
    from public.recipe_step
    where id = recipe_step_id
      and public.can_edit_recipe(recipe_id)
  )
)
with check (
  updated_by = public.current_account_id()
  and exists (
    select 1
    from public.recipe_step
    where id = recipe_step_id
      and public.can_edit_recipe(recipe_id)
  )
);

-- Comments are public to signed-in users but mutable only by their author or
-- an administrator.
drop policy if exists comment_read_authenticated on public.comment;
create policy comment_read_authenticated
on public.comment for select to authenticated using (true);
drop policy if exists comment_insert_own on public.comment;
create policy comment_insert_own
on public.comment for insert to authenticated
with check (
  public.current_account_can_write()
  and account_id = public.current_account_id()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);
drop policy if exists comment_update_own_or_admin on public.comment;
create policy comment_update_own_or_admin
on public.comment for update to authenticated
using (public.can_edit_account_owned(account_id))
with check (
  public.can_edit_account_owned(account_id)
  and updated_by = public.current_account_id()
);
drop policy if exists comment_delete_own_or_admin on public.comment;
create policy comment_delete_own_or_admin
on public.comment for delete to authenticated
using (public.can_edit_account_owned(account_id));

-- Account social data.
drop policy if exists account_follow_read_authenticated
  on public.account_follow;
create policy account_follow_read_authenticated
on public.account_follow for select to authenticated using (true);
drop policy if exists account_follow_insert_own on public.account_follow;
create policy account_follow_insert_own
on public.account_follow for insert to authenticated
with check (
  public.current_account_can_write()
  and follower_account_id = public.current_account_id()
  and followed_account_id <> public.current_account_id()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);
drop policy if exists account_follow_update_own on public.account_follow;
create policy account_follow_update_own
on public.account_follow for update to authenticated
using (
  public.current_account_can_write()
  and follower_account_id = public.current_account_id()
)
with check (
  follower_account_id = public.current_account_id()
  and updated_by = public.current_account_id()
);
drop policy if exists account_follow_delete_own on public.account_follow;
create policy account_follow_delete_own
on public.account_follow for delete to authenticated
using (follower_account_id = public.current_account_id());

drop policy if exists recipe_like_read_own on public.recipe_like;
create policy recipe_like_read_own
on public.recipe_like for select to authenticated
using (account_id = public.current_account_id());
drop policy if exists recipe_like_write_own on public.recipe_like;
create policy recipe_like_write_own
on public.recipe_like for all to authenticated
using (
  public.current_account_can_write()
  and account_id = public.current_account_id()
)
with check (
  public.current_account_can_write()
  and account_id = public.current_account_id()
  and updated_by = public.current_account_id()
);

-- Account-private data.
drop policy if exists history_private_own on public.history;
create policy history_private_own
on public.history for all to authenticated
using (account_id = public.current_account_id())
with check (
  account_id = public.current_account_id()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists setting_private_own on public.setting;
create policy setting_private_own
on public.setting for all to authenticated
using (account_id = public.current_account_id())
with check (
  account_id = public.current_account_id()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists shopping_list_private_own on public.shopping_list;
create policy shopping_list_private_own
on public.shopping_list for all to authenticated
using (account_id = public.current_account_id())
with check (
  public.current_account_can_write()
  and account_id = public.current_account_id()
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists shopping_list_item_private_own
  on public.shopping_list_item;
create policy shopping_list_item_private_own
on public.shopping_list_item for all to authenticated
using (public.owns_shopping_list(shopping_list_id))
with check (
  public.current_account_can_write()
  and public.owns_shopping_list(shopping_list_id)
  and created_by = public.current_account_id()
  and updated_by = public.current_account_id()
);

drop policy if exists meal_plan_entry_private_own
  on public.meal_plan_entry;
create policy meal_plan_entry_private_own
on public.meal_plan_entry for all to authenticated
using (public.can_edit_meal_plan(meal_plan_id))
with check (
  public.can_edit_meal_plan(meal_plan_id)
  and updated_by = public.current_account_id()
);

-- Device registration is retained for compatibility. It is available only
-- after authentication; the table currently has no account_id ownership
-- column, so it is not used as an authorization boundary.
drop policy if exists device_authenticated_read on public.device;
create policy device_authenticated_read
on public.device for select to authenticated using (true);
drop policy if exists device_authenticated_insert on public.device;
create policy device_authenticated_insert
on public.device for insert to authenticated with check (true);

-- host_codes intentionally has no table policy. Only validate_host_code() can
-- inspect it from an app client.

-- Storage object paths are generated as "<account_id>/<unique file>" by the
-- Flutter app. Public buckets retain public image reads, while writes require
-- ownership of the first folder and an editor/admin account role.
insert into storage.buckets (id, name, public)
values
  ('account-images', 'account-images', true),
  ('recipe-images', 'recipe-images', true)
on conflict (id) do update set public = excluded.public;

revoke select, insert, update, delete on table storage.objects from anon;
grant select, insert, update, delete on table storage.objects to authenticated;

do $$
declare
  v_policy record;
begin
  for v_policy in
    select policyname
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and (
        coalesce(qual, '') like '%account-images%'
        or coalesce(with_check, '') like '%account-images%'
        or coalesce(qual, '') like '%recipe-images%'
        or coalesce(with_check, '') like '%recipe-images%'
      )
  loop
    execute format(
      'drop policy %I on storage.objects',
      v_policy.policyname
    );
  end loop;
end
$$;

drop policy if exists "Account images are publicly uploadable"
  on storage.objects;
drop policy if exists account_images_insert_own_folder on storage.objects;
drop policy if exists account_images_select_own_folder on storage.objects;
drop policy if exists account_images_update_own_folder on storage.objects;
drop policy if exists account_images_delete_own_folder on storage.objects;
drop policy if exists recipe_images_insert_own_folder on storage.objects;
drop policy if exists recipe_images_select_own_folder on storage.objects;
drop policy if exists recipe_images_update_own_folder on storage.objects;
drop policy if exists recipe_images_delete_own_folder on storage.objects;

create policy account_images_select_own_folder
on storage.objects for select to authenticated
using (
  bucket_id = 'account-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
);

create policy account_images_insert_own_folder
on storage.objects for insert to authenticated
with check (
  bucket_id = 'account-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
  and public.current_account_can_write()
);

create policy account_images_update_own_folder
on storage.objects for update to authenticated
using (
  bucket_id = 'account-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
)
with check (
  bucket_id = 'account-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
  and public.current_account_can_write()
);

create policy account_images_delete_own_folder
on storage.objects for delete to authenticated
using (
  bucket_id = 'account-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
  and public.current_account_can_write()
);

create policy recipe_images_insert_own_folder
on storage.objects for insert to authenticated
with check (
  bucket_id = 'recipe-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
  and public.current_account_can_write()
);

create policy recipe_images_select_own_folder
on storage.objects for select to authenticated
using (
  bucket_id = 'recipe-images'
  and (
    (storage.foldername(name))[1] = public.current_account_id()::text
    or public.current_account_is_admin()
  )
);

create policy recipe_images_update_own_folder
on storage.objects for update to authenticated
using (
  bucket_id = 'recipe-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
)
with check (
  bucket_id = 'recipe-images'
  and (storage.foldername(name))[1] = public.current_account_id()::text
  and public.current_account_can_write()
);

create policy recipe_images_delete_own_folder
on storage.objects for delete to authenticated
using (
  bucket_id = 'recipe-images'
  and (
    (storage.foldername(name))[1] = public.current_account_id()::text
    or public.current_account_is_admin()
  )
  and public.current_account_can_write()
);

-- Optional role/permission tables are not used by the current Flutter app.
-- If they exist, enable RLS without client policies so they remain dashboard-
-- only until their exact purpose is implemented.
do $$
declare
  v_table_name text;
begin
  foreach v_table_name in array array[
    'permission',
    'permissions',
    'role_permission',
    'role_permissions'
  ]
  loop
    if to_regclass('public.' || v_table_name) is not null then
      execute format(
        'alter table public.%I enable row level security',
        v_table_name
      );
      execute format(
        'revoke all on table public.%I from anon, authenticated',
        v_table_name
      );
    end if;
  end loop;
end
$$;

commit;

-- Verification queries to run after the transaction:
--
-- select schemaname, tablename, rowsecurity
-- from pg_tables
-- where schemaname in ('public', 'storage')
-- order by schemaname, tablename;
--
-- select schemaname, tablename, policyname, cmd, roles
-- from pg_policies
-- where schemaname in ('public', 'storage')
-- order by schemaname, tablename, policyname;
