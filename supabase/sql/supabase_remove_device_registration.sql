-- Removes the legacy device registration table.
--
-- The app no longer records device identifiers. Push notification tokens are
-- stored separately in public.push_device (see
-- supabase_android_push_notifications.sql), which is not affected.

drop policy if exists device_authenticated_read on public.device;
drop policy if exists device_authenticated_insert on public.device;
drop table if exists public.device;
