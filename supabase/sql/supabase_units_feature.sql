-- Defined ingredient units. Run this once before launching the updated app.
create table if not exists public.unit (
  code character varying not null,
  name_en character varying not null,
  name_de character varying not null,
  sort_order integer not null,
  selectable boolean not null default true,
  created_at timestamp with time zone not null default now(),
  created_by bigint not null default 1,
  updated_at timestamp with time zone not null default now(),
  updated_by bigint not null default 1,
  deleted_at timestamp with time zone null,
  deleted_by bigint null,
  constraint unit_pkey primary key (code),
  constraint unit_created_by_fkey foreign key (created_by)
    references public.account (id),
  constraint unit_updated_by_fkey foreign key (updated_by)
    references public.account (id),
  constraint unit_deleted_by_fkey foreign key (deleted_by)
    references public.account (id)
);

insert into public.unit (code, name_en, name_de, sort_order)
values
  ('mg', 'milligram', 'Milligramm', 10),
  ('g', 'gram', 'Gramm', 20),
  ('kg', 'kilogram', 'Kilogramm', 30),
  ('ml', 'milliliter', 'Milliliter', 40),
  ('cl', 'centiliter', 'Zentiliter', 50),
  ('dl', 'deciliter', 'Deziliter', 60),
  ('l', 'liter', 'Liter', 70),
  ('tsp', 'teaspoon', 'Teelöffel', 80),
  ('tbsp', 'tablespoon', 'Esslöffel', 90),
  ('cup', 'cup', 'Tasse', 100),
  ('piece', 'piece', 'Stück', 110),
  ('pinch', 'pinch', 'Prise', 120),
  ('drop', 'drop', 'Tropfen', 130),
  ('clove', 'clove', 'Zehe', 140),
  ('slice', 'slice', 'Scheibe', 150),
  ('handful', 'handful', 'Handvoll', 160),
  ('bunch', 'bunch', 'Bund', 170),
  ('sprig', 'sprig', 'Zweig', 180),
  ('can', 'can', 'Dose', 190),
  ('package', 'package', 'Packung', 200),
  ('bottle', 'bottle', 'Flasche', 210),
  ('oz', 'ounce', 'Unze', 220),
  ('lb', 'pound', 'Pfund', 230),
  ('fl_oz', 'fluid ounce', 'Flüssigunze', 240)
on conflict (code) do update set
  name_en = excluded.name_en,
  name_de = excluded.name_de,
  sort_order = excluded.sort_order,
  selectable = true,
  updated_at = now(),
  updated_by = 1,
  deleted_at = null,
  deleted_by = null;

-- The user confirmed that existing ingredient data may be removed. Keeping the
-- deletion inside the constraint guard makes this file safe to rerun later.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'recipe_ingredient_unit_fkey'
      and conrelid = 'public.recipe_ingredient'::regclass
  ) then
    delete from public.recipe_step_ingredient;
    delete from public.recipe_ingredient;
    delete from public.ingredient;

    alter table public.recipe_ingredient
      add constraint recipe_ingredient_unit_fkey
      foreign key (unit) references public.unit (code)
      on update cascade;
  end if;
end
$$;
