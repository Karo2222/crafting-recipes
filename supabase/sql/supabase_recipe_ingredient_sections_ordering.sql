-- Recipe-specific ingredient sections and stable ingredient ordering.
-- Run this once in the Supabase SQL editor before using the updated app.
begin;

alter table public.recipe_ingredient
  add column if not exists section_name text;

do $migration$
begin
  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'recipe_ingredient'
      and column_name = 'sort_order'
  ) then
    alter table public.recipe_ingredient
      add column sort_order integer not null default 0;

    with ranked as (
      select
        recipe_id,
        ingredient_id,
        row_number() over (
          partition by recipe_id
          order by created_at, ingredient_id
        ) - 1 as position
      from public.recipe_ingredient
    )
    update public.recipe_ingredient as recipe_ingredient
    set sort_order = ranked.position
    from ranked
    where recipe_ingredient.recipe_id = ranked.recipe_id
      and recipe_ingredient.ingredient_id = ranked.ingredient_id;
  end if;
end
$migration$;

create index if not exists recipe_ingredient_recipe_sort_order_idx
  on public.recipe_ingredient (recipe_id, sort_order)
  where deleted_at is null;

create or replace function public.set_recipe_ingredient_layout(
  p_recipe_id bigint,
  p_layout jsonb
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_account_id bigint := public.current_account_id();
  v_item jsonb;
begin
  if v_account_id is null
      or not public.current_account_can_write()
      or not public.can_edit_recipe(p_recipe_id) then
    raise exception using
      errcode = '42501',
      message = 'recipe_access_denied';
  end if;

  for v_item in
    select value
    from jsonb_array_elements(coalesce(p_layout, '[]'::jsonb))
  loop
    update public.recipe_ingredient as recipe_ingredient
    set section_name = nullif(btrim(v_item->>'section_name'), ''),
        sort_order = greatest(
          coalesce((v_item->>'sort_order')::integer, 0),
          0
        ),
        updated_at = now(),
        updated_by = v_account_id
    from public.ingredient as ingredient
    where recipe_ingredient.recipe_id = p_recipe_id
      and recipe_ingredient.ingredient_id = ingredient.id
      and recipe_ingredient.deleted_at is null
      and ingredient.deleted_at is null
      and lower(btrim(ingredient.name)) =
          lower(btrim(v_item->>'name'));
  end loop;
end;
$$;

revoke all on function public.set_recipe_ingredient_layout(bigint, jsonb)
  from public;

grant execute on function public.set_recipe_ingredient_layout(bigint, jsonb)
  to authenticated;

commit;
