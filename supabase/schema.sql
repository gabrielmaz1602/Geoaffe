-- Geoaffe: Datenbank für Freunde und Ranglisten.
-- In Supabase unter "SQL Editor" komplett einfügen und auf "Run" klicken. Mehrfaches Ausführen ist unschädlich.
-- Spieler melden sich anonym an (ohne E-Mail); jeder sieht nur Name, Avatar und Punkte, nie Freundescodes anderer.

-- ---------- Tabellen ----------
create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null default '' check (char_length(name) <= 18),
  avatar jsonb not null default '{}'::jsonb,
  friend_code text not null unique default upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6)),
  created_at timestamptz not null default now()
);

create table if not exists public.results (
  user_id uuid not null references public.profiles(id) on delete cascade,
  day int not null,                                   -- Geoaffe-Nummer des Tages (Nr. 1 = 1. Januar 2026)
  game text not null check (game in ('pin', 'border', 'flag', 'nord', 'shape', 'size')),
  score int not null check (score between 0 and 500),
  created_at timestamptz not null default now(),
  primary key (user_id, day, game)
);

create table if not exists public.friendships (
  user_id uuid not null references public.profiles(id) on delete cascade,
  friend_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, friend_id),
  check (user_id <> friend_id)
);

alter table public.profiles enable row level security;
alter table public.results enable row level security;
alter table public.friendships enable row level security;

-- ---------- Rechte ----------
-- Freundescodes bleiben privat: andere Spieler dürfen nur id, Name und Avatar lesen.
revoke all on public.profiles, public.results, public.friendships from anon, authenticated;
grant select (id, name, avatar) on public.profiles to authenticated;
grant insert (id, name, avatar), update (name, avatar) on public.profiles to authenticated;
grant select, insert on public.results to authenticated;
grant select on public.friendships to authenticated;

-- heutige Geoaffe-Nummer (die App rechnet mit der Ortszeit, daher ±1 Tag Spielraum)
create or replace function public.geo_day() returns int language sql stable
as $$ select (current_date - date '2026-01-01') + 1 $$;

drop policy if exists "profiles lesen" on public.profiles;
create policy "profiles lesen" on public.profiles for select to authenticated using (true);
drop policy if exists "eigenes profil anlegen" on public.profiles;
create policy "eigenes profil anlegen" on public.profiles for insert to authenticated with check (id = auth.uid());
drop policy if exists "eigenes profil ändern" on public.profiles;
create policy "eigenes profil ändern" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- Ergebnisse: nur eigene eintragen, nur für heute (±1), nachträglich nicht änderbar
drop policy if exists "eigene ergebnisse eintragen" on public.results;
create policy "eigene ergebnisse eintragen" on public.results for insert to authenticated
  with check (user_id = auth.uid() and day between public.geo_day() - 1 and public.geo_day() + 1);
drop policy if exists "ergebnisse von mir und freunden lesen" on public.results;
create policy "ergebnisse von mir und freunden lesen" on public.results for select to authenticated
  using (user_id = auth.uid() or exists (select 1 from public.friendships f where f.user_id = auth.uid() and f.friend_id = results.user_id));

drop policy if exists "eigene freundschaften lesen" on public.friendships;
create policy "eigene freundschaften lesen" on public.friendships for select to authenticated using (user_id = auth.uid());

-- ---------- Funktionen, die die App aufruft ----------
-- eigenes Profil inklusive Freundescode
create or replace function public.my_profile() returns table (id uuid, name text, avatar jsonb, friend_code text)
language sql stable security definer set search_path = public
as $$ select p.id, p.name, p.avatar, p.friend_code from profiles p where p.id = auth.uid() $$;

-- Freund per Code hinzufügen (Freundschaft gilt in beide Richtungen)
create or replace function public.add_friend(code text) returns table (id uuid, name text, avatar jsonb)
language plpgsql security definer set search_path = public
as $$
declare other uuid;
begin
  if auth.uid() is null then raise exception 'not_signed_in'; end if;
  select p.id into other from profiles p where p.friend_code = upper(trim(code));
  if other is null then raise exception 'code_not_found'; end if;
  if other = auth.uid() then raise exception 'own_code'; end if;
  insert into friendships (user_id, friend_id) values (auth.uid(), other), (other, auth.uid()) on conflict do nothing;
  return query select p.id, p.name, p.avatar from profiles p where p.id = other;
end $$;

create or replace function public.remove_friend(fid uuid) returns void
language sql security definer set search_path = public
as $$ delete from friendships where (user_id = auth.uid() and friend_id = fid) or (user_id = fid and friend_id = auth.uid()) $$;

-- Rangliste: ich und meine Freunde, Punkte zwischen zwei Tagen (heute: von = bis)
create or replace function public.leaderboard_friends(day_from int, day_to int)
returns table (id uuid, name text, avatar jsonb, total int, games int, is_me boolean)
language sql stable security definer set search_path = public
as $$
  with people as (
    select auth.uid() as uid
    union select f.friend_id from friendships f where f.user_id = auth.uid()
  )
  select p.id, p.name, p.avatar, coalesce(sum(r.score), 0)::int, count(r.score)::int, p.id = auth.uid()
  from people x join profiles p on p.id = x.uid
  left join results r on r.user_id = p.id and r.day between day_from and day_to
  group by p.id order by 4 desc, p.name
$$;

-- Rangliste weltweit: die besten 50, dazu der eigene Platz
create or replace function public.leaderboard_global(day_from int, day_to int)
returns table (rank int, id uuid, name text, avatar jsonb, total int, is_me boolean)
language sql stable security definer set search_path = public
as $$
  with totals as (
    select r.user_id, sum(r.score)::int as total from results r where r.day between day_from and day_to group by r.user_id
  ), ranked as (
    select rank() over (order by t.total desc)::int as rank, t.user_id, t.total from totals t
  )
  select k.rank, p.id, p.name, p.avatar, k.total, p.id = auth.uid()
  from ranked k join profiles p on p.id = k.user_id
  where k.rank <= 50 or p.id = auth.uid()
  order by k.rank, p.name
$$;

-- Konto samt allen Daten löschen (Pflicht für Apps mit Konten im App Store)
create or replace function public.delete_me() returns void
language sql security definer set search_path = public, auth
as $$ delete from auth.users where id = auth.uid() $$;

revoke all on function public.my_profile(), public.add_friend(text), public.remove_friend(uuid), public.leaderboard_friends(int, int),
  public.leaderboard_global(int, int), public.delete_me() from public, anon;
grant execute on function public.my_profile(), public.add_friend(text), public.remove_friend(uuid), public.leaderboard_friends(int, int),
  public.leaderboard_global(int, int), public.delete_me(), public.geo_day() to authenticated;
