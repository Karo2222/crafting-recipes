-- Remap existing chat message IDs that JavaScript cannot represent exactly.
-- Run once in the Supabase SQL Editor after all devices have finished syncing.
-- After this succeeds, clear the browser's site data and reinstall development
-- builds on native devices so their local chat cache uses the remapped IDs.
begin;

lock table public.chat_message in access exclusive mode;
lock table public.chat_message_reaction in access exclusive mode;

-- Recreate this foreign key explicitly so the migration also works when an
-- older database created it without ON UPDATE CASCADE.
alter table public.chat_message_reaction
  drop constraint if exists chat_message_reaction_message_fkey;

do $$
declare
  unsafe_message record;
  next_magnitude bigint;
  replacement_id bigint;
  migration_time timestamptz := now();
begin
  select coalesce(max(-id), 0)::bigint
  into next_magnitude
  from public.chat_message
  where id between -9007199254740991 and -1;

  for unsafe_message in
    select id
    from public.chat_message
    where id < -9007199254740991
       or id > 9007199254740991
    order by created_at, id
  loop
    next_magnitude := next_magnitude + 1;
    if next_magnitude > 9007199254740991 then
      raise exception 'Not enough web-safe negative IDs are available';
    end if;
    replacement_id := -next_magnitude;

    update public.chat_message
    set id = replacement_id,
        updated_at = migration_time
    where id = unsafe_message.id;

    update public.chat_message_reaction
    set message_id = replacement_id,
        updated_at = migration_time
    where message_id = unsafe_message.id;
  end loop;
end
$$;

alter table public.chat_message
  drop constraint if exists chat_message_id_web_safe_check;
alter table public.chat_message
  add constraint chat_message_id_web_safe_check
  check (id between -9007199254740991 and 9007199254740991);

alter table public.chat_message_reaction
  add constraint chat_message_reaction_message_fkey
  foreign key (message_id)
  references public.chat_message (id)
  on update cascade
  on delete cascade;

notify pgrst, 'reload schema';
commit;

select count(*) as unsafe_chat_message_ids_remaining
from public.chat_message
where id < -9007199254740991
   or id > 9007199254740991;
