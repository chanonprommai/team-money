create table if not exists public.work_schedules (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  work_date date not null,
  job_title text not null,
  work_site text,
  start_time time,
  end_time time,
  attendees text,
  note text,
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists work_schedules_project_date_idx on public.work_schedules(project_id, work_date);
alter table public.work_schedules enable row level security;
drop policy if exists "Project members can view work schedules" on public.work_schedules;
create policy "Project members can view work schedules" on public.work_schedules for select to authenticated using (exists (select 1 from public.projects p where p.id=work_schedules.project_id and (p.created_by=(select auth.uid()) or public.is_project_member(p.id))));
drop policy if exists "Project members can create work schedules" on public.work_schedules;
create policy "Project members can create work schedules" on public.work_schedules for insert to authenticated with check (created_by=(select auth.uid()) and exists (select 1 from public.projects p where p.id=work_schedules.project_id and (p.created_by=(select auth.uid()) or public.is_project_member(p.id))));
drop policy if exists "Project members can update work schedules" on public.work_schedules;
create policy "Project members can update work schedules" on public.work_schedules for update to authenticated using (exists (select 1 from public.projects p where p.id=work_schedules.project_id and (p.created_by=(select auth.uid()) or public.is_project_member(p.id)))) with check (exists (select 1 from public.projects p where p.id=work_schedules.project_id and (p.created_by=(select auth.uid()) or public.is_project_member(p.id))));
drop policy if exists "Project members can delete work schedules" on public.work_schedules;
create policy "Project members can delete work schedules" on public.work_schedules for delete to authenticated using (exists (select 1 from public.projects p where p.id=work_schedules.project_id and (p.created_by=(select auth.uid()) or public.is_project_member(p.id))));