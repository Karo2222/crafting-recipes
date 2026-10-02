begin;

alter table public.recipe
  add column if not exists notes text null;

update public.recipe
set notes = null
where notes is not null
  and btrim(notes) = '';

commit;
