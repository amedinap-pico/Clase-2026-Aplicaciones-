create table if not exists public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  creado_en timestamptz not null default now()
);

alter table public.perfiles enable row level security;

drop policy if exists "cualquiera autenticado ve los perfiles" on public.perfiles;
create policy "cualquiera autenticado ve los perfiles"
on public.perfiles for select
to authenticated
using (true);

drop policy if exists "cada quien crea solo su perfil" on public.perfiles;
create policy "cada quien crea solo su perfil"
on public.perfiles for insert
to authenticated
with check (auth.uid() = id);
