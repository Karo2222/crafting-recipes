-- Supabase Auth foundation for the existing public.account table.
-- This intentionally does NOT enable RLS on the existing app tables yet.
-- Run this file before using the email/password login in the app.

begin;

alter table public.account
  add column if not exists auth_user_id uuid null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'account_auth_user_id_fkey'
      and conrelid = 'public.account'::regclass
  ) then
    alter table public.account
      add constraint account_auth_user_id_fkey
      foreign key (auth_user_id)
      references auth.users (id);
  end if;
end
$$;

create unique index if not exists account_auth_user_id_key
  on public.account (auth_user_id)
  where auth_user_id is not null;

-- RLS policies can use this later instead of trusting an account ID sent by
-- the app. The function only returns the account linked to the current JWT.
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

revoke all on function public.current_account_id() from public;
grant execute on function public.current_account_id() to authenticated;

commit;

-- EXISTING ACCOUNTS
-- First create each existing user under Authentication > Users in the
-- Supabase dashboard. Then run this statement to link matching email addresses:
--
-- update public.account as account
-- set auth_user_id = auth_user.id
-- from auth.users as auth_user
-- where account.auth_user_id is null
--   and lower(account.email) = lower(auth_user.email);
--
-- If an existing account has no email yet, link it directly with the UUID
-- shown for that user under Authentication > Users. For example, for Garo:
--
-- update public.account
-- set email = 'GAROS_AUTH_EMAIL',
--     auth_user_id = 'GAROS_AUTH_USER_UUID'
-- where id = 1;
--
-- Verify that every active account is linked before RLS is enabled later:
--
-- select id, account_name, email, auth_user_id
-- from public.account
-- where deleted_at is null
-- order by id;
