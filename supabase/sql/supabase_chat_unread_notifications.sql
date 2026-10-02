-- Persisted unread state for direct chat messages.
-- Run this file once in the Supabase SQL Editor.
begin;

alter table public.chat_message
  add column if not exists read_at timestamp with time zone null;

create or replace function public.mark_chat_messages_read(
  p_friend_account_id bigint
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_account_id bigint := public.current_account_id();
  v_first bigint;
  v_second bigint;
  v_read_at timestamp with time zone := now();
begin
  if v_account_id is null or p_friend_account_id = v_account_id then
    raise exception 'invalid_chat_participant';
  end if;

  v_first := least(v_account_id, p_friend_account_id);
  v_second := greatest(v_account_id, p_friend_account_id);

  update public.chat_message
  set read_at = v_read_at,
      updated_at = greatest(updated_at, v_read_at),
      updated_by = v_account_id
  where first_account_id = v_first
    and second_account_id = v_second
    and sender_account_id = p_friend_account_id
    and read_at is null
    and deleted_at is null;
end
$$;

revoke all on function public.mark_chat_messages_read(bigint)
  from public, anon;
grant execute on function public.mark_chat_messages_read(bigint)
  to authenticated;

notify pgrst, 'reload schema';
commit;
