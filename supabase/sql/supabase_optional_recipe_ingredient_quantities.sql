begin;

alter table public.recipe_ingredient
  alter column amount drop not null,
  alter column unit drop not null,
  add column if not exists quantity_note character varying null;

update public.recipe_ingredient
set quantity_note = null
where quantity_note is not null
  and btrim(quantity_note) = '';

alter table public.recipe_ingredient
  drop constraint if exists recipe_ingredient_quantity_pair_check;

alter table public.recipe_ingredient
  add constraint recipe_ingredient_quantity_pair_check check (
    (amount is null and unit is null)
    or (
      amount is not null
      and amount > 0
      and unit is not null
      and btrim(unit) <> ''
    )
  );

commit;
