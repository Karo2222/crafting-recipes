-- Account-level recipe likes. No trigger or RPC is used; the app writes all
-- audit fields explicitly.
create table if not exists public.recipe_like (
  account_id bigint not null,
  recipe_id bigint not null,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint recipe_like_pkey primary key (account_id, recipe_id),
  constraint recipe_like_account_id_fkey foreign key (account_id)
    references public.account (id) on update cascade on delete cascade,
  constraint recipe_like_recipe_id_fkey foreign key (recipe_id)
    references public.recipe (id) on update cascade on delete cascade,
  constraint recipe_like_created_by_fkey foreign key (created_by)
    references public.account (id) on update cascade,
  constraint recipe_like_updated_by_fkey foreign key (updated_by)
    references public.account (id) on update cascade,
  constraint recipe_like_deleted_by_fkey foreign key (deleted_by)
    references public.account (id) on update cascade
);

create index if not exists recipe_like_account_active_idx
  on public.recipe_like (account_id, recipe_id)
  where deleted_at is null;

create index if not exists recipe_like_recipe_active_idx
  on public.recipe_like (recipe_id, account_id)
  where deleted_at is null;
