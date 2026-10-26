-- Geoaffe: Nutzerkonten (Okt. 2026). Einmal im Supabase SQL Editor ausführen.

-- 1. Weltrangliste entfernen
drop function if exists public.leaderboard_global(int, int);

-- 2. Spielstand im Konto (Punkte, Serie, Bananen, Avatar, Einstellungen), damit er auf einem neuen Handy wieder da ist
create table if not exists public.user_state (
  user_id uuid primary key references auth.users on delete cascade,
  state jsonb not null default '{}'::jsonb check (pg_column_size(state) < 300000),
  updated_at timestamptz not null default now()
);
alter table public.user_state enable row level security;
drop policy if exists "eigenen spielstand lesen" on public.user_state;
create policy "eigenen spielstand lesen" on public.user_state for select to authenticated using (user_id = auth.uid());
drop policy if exists "eigenen spielstand anlegen" on public.user_state;
create policy "eigenen spielstand anlegen" on public.user_state for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "eigenen spielstand ändern" on public.user_state;
create policy "eigenen spielstand ändern" on public.user_state for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
