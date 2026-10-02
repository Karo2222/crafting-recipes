-- Atomic upload for recipes created offline with client-generated bigint IDs.
begin;

alter table public.recipe
  add column if not exists last_mutation_id text,
  add column if not exists notes text;

drop function if exists public.create_recipe_with_details_offline(
  bigint, bigint, text, text, text, jsonb, jsonb, bigint[], integer, integer
);

drop function if exists public.create_recipe_with_details_offline(
  bigint, bigint, text, text, text, jsonb, jsonb, bigint[], integer, integer,
  text
);

drop function if exists public.create_recipe_with_details_offline(
  bigint, bigint, text, text, text, text, jsonb, jsonb, bigint[], integer,
  integer, text
);

create or replace function public.create_recipe_with_details_offline(
  p_account_id bigint,
  p_recipe_id bigint,
  p_title text,
  p_description text,
  p_notes text,
  p_image text,
  p_ingredients jsonb,
  p_steps jsonb,
  p_category_ids bigint[],
  p_total_time_minutes integer,
  p_servings integer,
  p_mutation_id text
)
returns bigint
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_now timestamptz := now();
  v_ingredient jsonb;
  v_step jsonb;
  v_index jsonb;
  v_ingredient_id bigint;
  v_ingredient_ids bigint[] := array[]::bigint[];
  v_existing_mutation_id text;
begin
  if p_account_id is distinct from public.current_account_id()
      or not public.current_account_can_write() then
    raise exception using errcode = '42501', message = 'recipe_access_denied';
  end if;

  select recipe.last_mutation_id
  into v_existing_mutation_id
  from public.recipe as recipe
  where recipe.id = p_recipe_id;

  if found then
    if v_existing_mutation_id is not distinct from p_mutation_id then
      return p_recipe_id;
    end if;
    raise exception using errcode = '23505', message = 'recipe_id_conflict';
  end if;

  insert into public.recipe (
    id, title, description, notes, image, total_time_minutes, servings, revision,
    last_mutation_id,
    created_at, created_by, updated_at, updated_by
  ) values (
    p_recipe_id, btrim(p_title), nullif(btrim(p_description), ''),
    nullif(btrim(p_notes), ''), p_image,
    p_total_time_minutes, p_servings, 1, p_mutation_id,
    v_now, p_account_id, v_now, p_account_id
  );

  for v_ingredient in
    select value from jsonb_array_elements(coalesce(p_ingredients, '[]'))
  loop
    select ingredient.id into v_ingredient_id
    from public.ingredient as ingredient
    where ingredient.deleted_at is null
      and lower(btrim(ingredient.name)) =
          lower(btrim(v_ingredient->>'name'))
    limit 1;

    if v_ingredient_id is null then
      v_ingredient_id := (v_ingredient->>'id')::bigint;
      insert into public.ingredient (
        id, name, created_at, created_by, updated_at, updated_by
      ) values (
        v_ingredient_id, btrim(v_ingredient->>'name'),
        v_now, p_account_id, v_now, p_account_id
      ) on conflict (id) do nothing;
    end if;

    v_ingredient_ids := array_append(v_ingredient_ids, v_ingredient_id);
    insert into public.recipe_ingredient (
      recipe_id, ingredient_id, amount, unit, quantity_note,
      created_at, created_by, updated_at, updated_by
    ) values (
      p_recipe_id, v_ingredient_id,
      nullif(v_ingredient->>'amount', '')::double precision,
      nullif(btrim(v_ingredient->>'unit'), ''),
      nullif(btrim(v_ingredient->>'quantity_note'), ''),
      v_now, p_account_id, v_now, p_account_id
    ) on conflict (recipe_id, ingredient_id) do update set
      amount = excluded.amount,
      unit = excluded.unit,
      quantity_note = excluded.quantity_note,
      updated_at = excluded.updated_at,
      updated_by = excluded.updated_by,
      deleted_at = null,
      deleted_by = null;
  end loop;

  for v_step in
    select value from jsonb_array_elements(coalesce(p_steps, '[]'))
  loop
    insert into public.recipe_step (
      id, recipe_id, step_nr, description, image,
      created_at, created_by, updated_at, updated_by
    ) values (
      (v_step->>'id')::bigint, p_recipe_id, (v_step->>'step_nr')::integer,
      v_step->>'description', nullif(v_step->>'image', ''),
      v_now, p_account_id, v_now, p_account_id
    ) on conflict (id) do nothing;

    for v_index in
      select value from jsonb_array_elements(
        coalesce(v_step->'ingredient_indexes', '[]')
      )
    loop
      v_ingredient_id := v_ingredient_ids[(v_index::text)::integer + 1];
      if v_ingredient_id is not null then
        insert into public.recipe_step_ingredient (
          recipe_step_id, ingredient_id,
          created_at, created_by, updated_at, updated_by
        ) values (
          (v_step->>'id')::bigint, v_ingredient_id,
          v_now, p_account_id, v_now, p_account_id
        ) on conflict (recipe_step_id, ingredient_id) do nothing;
      end if;
    end loop;
  end loop;

  insert into public.recipe_category (
    recipe_id, category_id, created_at, created_by, updated_at, updated_by
  )
  select p_recipe_id, category_id, v_now, p_account_id, v_now, p_account_id
  from unnest(coalesce(p_category_ids, array[]::bigint[])) as category_id
  on conflict (recipe_id, category_id) do update set
    updated_at = excluded.updated_at,
    updated_by = excluded.updated_by,
    deleted_at = null,
    deleted_by = null;

  return p_recipe_id;
end;
$$;

revoke all on function public.create_recipe_with_details_offline(
  bigint, bigint, text, text, text, text, jsonb, jsonb, bigint[], integer,
  integer, text
) from public, anon;
grant execute on function public.create_recipe_with_details_offline(
  bigint, bigint, text, text, text, text, jsonb, jsonb, bigint[], integer,
  integer, text
) to authenticated;

notify pgrst, 'reload schema';
commit;
