-- Account page fields. Existing accounts remain valid because both are optional.
alter table public.account
  add column if not exists profile_image character varying null,
  add column if not exists bio character varying null;

-- Public account-to-account follows. No trigger is used; the app writes all
-- audit fields explicitly, like the other current app flows.
create table if not exists public.account_follow (
  follower_account_id bigint not null,
  followed_account_id bigint not null,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint account_follow_pkey primary key (
    follower_account_id,
    followed_account_id
  ),
  constraint account_follow_follower_account_id_fkey foreign key (
    follower_account_id
  ) references public.account (id) on update cascade on delete cascade,
  constraint account_follow_followed_account_id_fkey foreign key (
    followed_account_id
  ) references public.account (id) on update cascade on delete cascade,
  constraint account_follow_created_by_fkey foreign key (
    created_by
  ) references public.account (id) on update cascade,
  constraint account_follow_updated_by_fkey foreign key (
    updated_by
  ) references public.account (id) on update cascade,
  constraint account_follow_deleted_by_fkey foreign key (
    deleted_by
  ) references public.account (id) on update cascade
);

create index if not exists account_follow_followed_account_id_idx
  on public.account_follow (followed_account_id)
  where deleted_at is null;

create index if not exists account_follow_follower_account_id_idx
  on public.account_follow (follower_account_id)
  where deleted_at is null;

-- Storage access is defined centrally in supabase_rls_policies.sql. Keeping the
-- bucket public allows profile images to render without signed URLs; writes and
-- cleanup still require an authenticated, authorized account.
insert into storage.buckets (id, name, public)
values ('account-images', 'account-images', true)
on conflict (id) do update set public = excluded.public;
