-- ALERTE JZ — V11 SÉCURISÉE
-- À exécuter UNE FOIS dans Supabase > SQL Editor APRÈS la V10.
-- Objectif : interdire l'accès aux données aux visiteurs non connectés
-- et autoriser uniquement les utilisateurs Supabase Auth authentifiés.

begin;

-- 1) Plus aucun accès aux tables pour le rôle public non connecté (anon)
revoke all on public.rooms, public.exercises, public.room_states, public.room_status_events, public.exercise_archives from anon;
revoke all on function public.ensure_active_exercise() from anon;
revoke all on function public.start_new_exercise() from anon;
revoke all on function public.record_room_status(bigint,text,text,text,text) from anon;

-- 2) Droits minimum nécessaires pour les utilisateurs connectés
grant usage on schema public to authenticated;
grant select on public.rooms, public.exercises, public.room_states, public.room_status_events to authenticated;
grant select, insert, delete on public.exercise_archives to authenticated;
grant usage, select on sequence public.exercise_archives_id_seq to authenticated;
grant execute on function public.ensure_active_exercise() to authenticated;
grant execute on function public.start_new_exercise() to authenticated;
grant execute on function public.record_room_status(bigint,text,text,text,text) to authenticated;

-- 3) RLS : remplacement des anciennes règles V10 ouvertes à anon
alter table public.rooms enable row level security;
alter table public.exercises enable row level security;
alter table public.room_states enable row level security;
alter table public.room_status_events enable row level security;
alter table public.exercise_archives enable row level security;

drop policy if exists "read rooms" on public.rooms;
drop policy if exists "read exercises" on public.exercises;
drop policy if exists "read room states" on public.room_states;
drop policy if exists "read events" on public.room_status_events;
drop policy if exists "read archives" on public.exercise_archives;
drop policy if exists "insert archives" on public.exercise_archives;
drop policy if exists "delete archives" on public.exercise_archives;

create policy "read rooms" on public.rooms
  for select to authenticated using (true);
create policy "read exercises" on public.exercises
  for select to authenticated using (true);
create policy "read room states" on public.room_states
  for select to authenticated using (true);
create policy "read events" on public.room_status_events
  for select to authenticated using (true);
create policy "read archives" on public.exercise_archives
  for select to authenticated using (true);
create policy "insert archives" on public.exercise_archives
  for insert to authenticated with check (true);
create policy "delete archives" on public.exercise_archives
  for delete to authenticated using (true);

commit;
