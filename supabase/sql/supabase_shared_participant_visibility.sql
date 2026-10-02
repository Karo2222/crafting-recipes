begin;

drop policy if exists shopping_list_member_read
  on public.shopping_list_member;
create policy shopping_list_member_read on public.shopping_list_member
for select to authenticated using (
  account_id = public.current_account_id()
  or exists (
    select 1
    from public.shopping_list as list
    where list.id = shopping_list_id
      and list.account_id = public.current_account_id()
  )
  or (
    status = 'accepted'
    and public.can_view_shopping_list(shopping_list_id)
  )
);

drop policy if exists meal_plan_member_read
  on public.meal_plan_member;
create policy meal_plan_member_read on public.meal_plan_member
for select to authenticated using (
  account_id = public.current_account_id()
  or exists (
    select 1
    from public.meal_plan as plan
    where plan.id = meal_plan_id
      and plan.account_id = public.current_account_id()
  )
  or (
    status = 'accepted'
    and public.can_view_meal_plan(meal_plan_id)
  )
);

-- Make existing membership rows pass the app's incremental sync cursor once.
update public.shopping_list_member
set updated_at = now()
where deleted_at is null;

update public.meal_plan_member
set updated_at = now()
where deleted_at is null;

notify pgrst, 'reload schema';

commit;
