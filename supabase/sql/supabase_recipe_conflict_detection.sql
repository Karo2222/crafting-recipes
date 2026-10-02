-- Prevent a stale recipe editor from silently overwriting a newer remote edit.
-- Synchronize retained child rows in place so their IDs and creation metadata
-- remain stable across recipe edits.
begin;

alter table public.recipe
  add column if not exists revision bigint not null default 1,
  add column if not exists last_mutation_id text,
  add column if not exists notes text;

drop function if exists public.update_recipe_with_details_if_unchanged(
  bigint,
  bigint,
  text,
  text,
  text,
  jsonb,
  jsonb,
  bigint[],
  timestamp with time zone
);

drop function if exists public.update_recipe_with_details_if_unchanged(
  bigint, bigint, text, text, text, jsonb, jsonb, bigint[], integer, integer,
  bigint
);

drop function if exists public.update_recipe_with_details_if_unchanged(
  bigint, bigint, text, text, text, jsonb, jsonb, bigint[], integer, integer,
  bigint, text
);

drop function if exists public.update_recipe_with_details_if_unchanged(
  bigint, bigint, text, text, text, text, jsonb, jsonb, bigint[], integer,
  integer, bigint, text
);

create or replace function public.update_recipe_with_details_if_unchanged(
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
  p_expected_revision bigint,
  p_mutation_id text
)
returns bigint
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_remote_revision bigint;
  v_last_mutation_id text;
  v_now timestamptz := now();
  v_ingredient jsonb;
  v_step jsonb;
  v_index jsonb;
  v_ingredient_id bigint;
  v_ingredient_ids bigint[] := array[]::bigint[];
  v_step_id bigint;
  v_step_ids bigint[] := array[]::bigint[];
  v_step_ingredient_ids bigint[];
begin
  if p_account_id is distinct from public.current_account_id()
      or not public.current_account_can_write() then
    raise exception using errcode = '42501', message = 'recipe_access_denied';
  end if;

  select recipe.revision, recipe.last_mutation_id
  into v_remote_revision, v_last_mutation_id
  from public.recipe as recipe
  where recipe.id = p_recipe_id
    and recipe.deleted_at is null
  for update;

  if not found then
    raise exception using
      errcode = 'P0001',
      message = 'recipe_not_found';
  end if;

  if v_last_mutation_id is not distinct from p_mutation_id then
    return p_recipe_id;
  end if;

  if v_remote_revision is distinct from p_expected_revision then
    raise exception using
      errcode = 'P0001',
      message = 'recipe_edit_conflict';
  end if;

  update public.recipe
  set title = btrim(p_title),
      description = nullif(btrim(p_description), ''),
      notes = nullif(btrim(p_notes), ''),
      image = p_image,
      total_time_minutes = p_total_time_minutes,
      servings = p_servings,
      revision = revision + 1,
      last_mutation_id = p_mutation_id,
      updated_at = v_now,
      updated_by = p_account_id,
      deleted_at = null,
      deleted_by = null
  where id = p_recipe_id;

  select coalesce(
    array_agg((step.value->>'id')::bigint),
    array[]::bigint[]
  )
  into v_step_ids
  from jsonb_array_elements(coalesce(p_steps, '[]')) as step(value);

  update public.recipe_step_ingredient as step_ingredient
  set deleted_at = v_now,
      deleted_by = p_account_id,
      updated_at = v_now,
      updated_by = p_account_id
  from public.recipe_step as step
  where step_ingredient.recipe_step_id = step.id
    and step.recipe_id = p_recipe_id
    and not (step.id = any(v_step_ids))
    and step_ingredient.deleted_at is null;

  update public.recipe_step
  set deleted_at = v_now,
      deleted_by = p_account_id,
      updated_at = v_now,
      updated_by = p_account_id
  where recipe_id = p_recipe_id
    and not (id = any(v_step_ids))
    and deleted_at is null;

  for v_ingredient in
    select value from jsonb_array_elements(coalesce(p_ingredients, '[]'))
  loop
    v_ingredient_id := null;
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
      );
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

  update public.recipe_ingredient
  set deleted_at = v_now,
      deleted_by = p_account_id,
      updated_at = v_now,
      updated_by = p_account_id
  where recipe_id = p_recipe_id
    and not (ingredient_id = any(v_ingredient_ids))
    and deleted_at is null;

  for v_step in
    select value from jsonb_array_elements(coalesce(p_steps, '[]'))
  loop
    v_step_id := (v_step->>'id')::bigint;
    v_step_ingredient_ids := array[]::bigint[];

    insert into public.recipe_step (
      id, recipe_id, step_nr, description, image,
      created_at, created_by, updated_at, updated_by
    ) values (
      v_step_id, p_recipe_id, (v_step->>'step_nr')::integer,
      v_step->>'description', nullif(v_step->>'image', ''),
      v_now, p_account_id, v_now, p_account_id
    ) on conflict (id) do update set
      step_nr = excluded.step_nr,
      description = excluded.description,
      image = excluded.image,
      updated_at = excluded.updated_at,
      updated_by = excluded.updated_by,
      deleted_at = null,
      deleted_by = null
    where recipe_step.recipe_id = p_recipe_id;

    for v_index in
      select value from jsonb_array_elements(
        coalesce(v_step->'ingredient_indexes', '[]')
      )
    loop
      v_ingredient_id := v_ingredient_ids[(v_index::text)::integer + 1];
      if v_ingredient_id is not null then
        v_step_ingredient_ids :=
            array_append(v_step_ingredient_ids, v_ingredient_id);
        insert into public.recipe_step_ingredient (
          recipe_step_id, ingredient_id,
          created_at, created_by, updated_at, updated_by
        ) values (
          v_step_id, v_ingredient_id,
          v_now, p_account_id, v_now, p_account_id
        ) on conflict (recipe_step_id, ingredient_id) do update set
          updated_at = excluded.updated_at,
          updated_by = excluded.updated_by,
          deleted_at = null,
          deleted_by = null;
      end if;
    end loop;

    update public.recipe_step_ingredient
    set deleted_at = v_now,
        deleted_by = p_account_id,
        updated_at = v_now,
        updated_by = p_account_id
    where recipe_step_id = v_step_id
      and not (ingredient_id = any(v_step_ingredient_ids))
      and deleted_at is null;
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

  update public.recipe_category
  set deleted_at = v_now,
      deleted_by = p_account_id,
      updated_at = v_now,
      updated_by = p_account_id
  where recipe_id = p_recipe_id
    and not (category_id = any(coalesce(
      p_category_ids,
      array[]::bigint[]
    )))
    and deleted_at is null;

  return p_recipe_id;
end;
$$;

revoke all on function public.update_recipe_with_details_if_unchanged(
  bigint,
  bigint,
  text,
  text,
  text,
  text,
  jsonb,
  jsonb,
  bigint[],
  integer,
  integer,
  bigint,
  text
) from public, anon;

grant execute on function public.update_recipe_with_details_if_unchanged(
  bigint,
  bigint,
  text,
  text,
  text,
  text,
  jsonb,
  jsonb,
  bigint[],
  integer,
  integer,
  bigint,
  text
) to authenticated;

notify pgrst, 'reload schema';
commit;
