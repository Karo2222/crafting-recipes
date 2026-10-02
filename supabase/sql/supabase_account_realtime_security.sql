-- Fix account Realtime reconnects without exposing private account columns.
begin;

alter table public.account enable row level security;

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

drop policy if exists account_read_authenticated on public.account;
create policy account_read_authenticated
on public.account for select to authenticated
using (id = public.current_account_id());

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

notify pgrst, 'reload schema';
commit;
