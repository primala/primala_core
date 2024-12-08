drop policy "SELECT: Users can read their past Nokhte Sessions" on "public"."finished_nokhte_sessions";

drop policy "UPDATE: They can only update their row" on "public"."finished_nokhte_sessions";

drop policy "INSERT: can insert row if leader of their session" on "public"."rt_active_nokhte_sessions";

drop policy "SELECT: They can read their own row" on "public"."rt_active_nokhte_sessions";

drop policy "UPDATE: They can update their row if is a valid session" on "public"."rt_active_nokhte_sessions";

drop policy "SELECT: They can read their row" on "public"."st_active_nokhte_sessions";

drop policy "UPDATE: Can update valid rows" on "public"."st_active_nokhte_sessions";

drop policy "can insert a row if they are the leader" on "public"."st_active_nokhte_sessions";

revoke delete on table "public"."finished_nokhte_sessions" from "anon";

revoke insert on table "public"."finished_nokhte_sessions" from "anon";

revoke references on table "public"."finished_nokhte_sessions" from "anon";

revoke select on table "public"."finished_nokhte_sessions" from "anon";

revoke trigger on table "public"."finished_nokhte_sessions" from "anon";

revoke truncate on table "public"."finished_nokhte_sessions" from "anon";

revoke update on table "public"."finished_nokhte_sessions" from "anon";

revoke delete on table "public"."finished_nokhte_sessions" from "authenticated";

revoke insert on table "public"."finished_nokhte_sessions" from "authenticated";

revoke references on table "public"."finished_nokhte_sessions" from "authenticated";

revoke select on table "public"."finished_nokhte_sessions" from "authenticated";

revoke trigger on table "public"."finished_nokhte_sessions" from "authenticated";

revoke truncate on table "public"."finished_nokhte_sessions" from "authenticated";

revoke update on table "public"."finished_nokhte_sessions" from "authenticated";

revoke delete on table "public"."finished_nokhte_sessions" from "service_role";

revoke insert on table "public"."finished_nokhte_sessions" from "service_role";

revoke references on table "public"."finished_nokhte_sessions" from "service_role";

revoke select on table "public"."finished_nokhte_sessions" from "service_role";

revoke trigger on table "public"."finished_nokhte_sessions" from "service_role";

revoke truncate on table "public"."finished_nokhte_sessions" from "service_role";

revoke update on table "public"."finished_nokhte_sessions" from "service_role";

revoke delete on table "public"."rt_active_nokhte_sessions" from "anon";

revoke insert on table "public"."rt_active_nokhte_sessions" from "anon";

revoke references on table "public"."rt_active_nokhte_sessions" from "anon";

revoke select on table "public"."rt_active_nokhte_sessions" from "anon";

revoke trigger on table "public"."rt_active_nokhte_sessions" from "anon";

revoke truncate on table "public"."rt_active_nokhte_sessions" from "anon";

revoke update on table "public"."rt_active_nokhte_sessions" from "anon";

revoke delete on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke insert on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke references on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke select on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke trigger on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke truncate on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke update on table "public"."rt_active_nokhte_sessions" from "authenticated";

revoke delete on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke insert on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke references on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke select on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke trigger on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke truncate on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke update on table "public"."rt_active_nokhte_sessions" from "service_role";

revoke delete on table "public"."st_active_nokhte_sessions" from "anon";

revoke insert on table "public"."st_active_nokhte_sessions" from "anon";

revoke references on table "public"."st_active_nokhte_sessions" from "anon";

revoke select on table "public"."st_active_nokhte_sessions" from "anon";

revoke trigger on table "public"."st_active_nokhte_sessions" from "anon";

revoke truncate on table "public"."st_active_nokhte_sessions" from "anon";

revoke update on table "public"."st_active_nokhte_sessions" from "anon";

revoke delete on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke insert on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke references on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke select on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke trigger on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke truncate on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke update on table "public"."st_active_nokhte_sessions" from "authenticated";

revoke delete on table "public"."st_active_nokhte_sessions" from "service_role";

revoke insert on table "public"."st_active_nokhte_sessions" from "service_role";

revoke references on table "public"."st_active_nokhte_sessions" from "service_role";

revoke select on table "public"."st_active_nokhte_sessions" from "service_role";

revoke trigger on table "public"."st_active_nokhte_sessions" from "service_role";

revoke truncate on table "public"."st_active_nokhte_sessions" from "service_role";

revoke update on table "public"."st_active_nokhte_sessions" from "service_role";

alter table "public"."rt_active_nokhte_sessions" drop constraint "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."rt_active_nokhte_sessions" drop constraint "rt_active_nokhte_sessions_secondary_speaker_spotlight_fkey";

alter table "public"."rt_active_nokhte_sessions" drop constraint "rt_active_nokhte_sessions_session_uid_fkey";

alter table "public"."rt_active_nokhte_sessions" drop constraint "rt_active_nokhte_sessions_speaker_spotlight_fkey";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_duplicate_collaborator_uids_key";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_duplicate_session_uid_key";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_leader_uid_fkey";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_leader_uid_key";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_preset_uid_fkey";

alter table "public"."finished_nokhte_sessions" drop constraint "finished_nokhte_sessions_pkey";

alter table "public"."rt_active_nokhte_sessions" drop constraint "rt_active_nokhte_sessions_pkey";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_pkey";

drop index if exists "public"."finished_nokhte_sessions_collaborator_uids_idx";

drop index if exists "public"."active_irl_nokhte_sessions_session_uid_key";

drop index if exists "public"."finished_nokhte_sessions_pkey";

drop index if exists "public"."rt_active_nokhte_sessions_pkey";

drop index if exists "public"."st_active_nokhte_sessions_duplicate_collaborator_uids_key";

drop index if exists "public"."st_active_nokhte_sessions_duplicate_session_uid_key";

drop index if exists "public"."st_active_nokhte_sessions_leader_uid_key";

drop index if exists "public"."st_active_nokhte_sessions_pkey";

drop table "public"."finished_nokhte_sessions";

drop table "public"."rt_active_nokhte_sessions";

drop table "public"."st_active_nokhte_sessions";

create table "public"."finished_sessions" (
    "session_timestamp" timestamp with time zone not null,
    "content" text[] not null default '{}'::text[],
    "session_uid" uuid not null,
    "group_uid" uuid not null
);


alter table "public"."finished_sessions" enable row level security;

create table "public"."realtime_active_sessions" (
    "current_phases" real[] not null default '{0}'::real[],
    "is_online" boolean[] not null default '{t}'::boolean[],
    "session_uid" uuid not null,
    "has_begun" boolean not null default false,
    "speaker_spotlight" uuid,
    "version" integer not null default 0,
    "secondary_speaker_spotlight" uuid,
    "speaking_timer_start" timestamp with time zone,
    "content" text[] not null default '{}'::text[]
);


alter table "public"."realtime_active_sessions" enable row level security;

create table "public"."static_active_sessions" (
    "created_at" timestamp with time zone not null default now(),
    "collaborator_uids" uuid[] not null,
    "session_uid" uuid not null default gen_random_uuid(),
    "leader_uid" uuid not null default auth.uid(),
    "preset_uid" uuid not null,
    "version" integer not null default 0,
    "collaborator_names" text[] not null,
    "group_uid" uuid
);


alter table "public"."static_active_sessions" enable row level security;

CREATE UNIQUE INDEX active_irl_nokhte_sessions_session_uid_key ON public.realtime_active_sessions USING btree (session_uid);

CREATE UNIQUE INDEX finished_nokhte_sessions_pkey ON public.finished_sessions USING btree (session_uid);

CREATE UNIQUE INDEX rt_active_nokhte_sessions_pkey ON public.realtime_active_sessions USING btree (session_uid);

CREATE UNIQUE INDEX st_active_nokhte_sessions_duplicate_collaborator_uids_key ON public.static_active_sessions USING btree (collaborator_uids);

CREATE UNIQUE INDEX st_active_nokhte_sessions_duplicate_session_uid_key ON public.static_active_sessions USING btree (session_uid);

CREATE UNIQUE INDEX st_active_nokhte_sessions_leader_uid_key ON public.static_active_sessions USING btree (leader_uid);

CREATE UNIQUE INDEX st_active_nokhte_sessions_pkey ON public.static_active_sessions USING btree (session_uid);

alter table "public"."finished_sessions" add constraint "finished_nokhte_sessions_pkey" PRIMARY KEY using index "finished_nokhte_sessions_pkey";

alter table "public"."realtime_active_sessions" add constraint "rt_active_nokhte_sessions_pkey" PRIMARY KEY using index "rt_active_nokhte_sessions_pkey";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_pkey" PRIMARY KEY using index "st_active_nokhte_sessions_pkey";

alter table "public"."finished_sessions" add constraint "finished_sessions_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) not valid;

alter table "public"."finished_sessions" validate constraint "finished_sessions_group_uid_fkey";

alter table "public"."realtime_active_sessions" add constraint "active_irl_nokhte_sessions_session_uid_key" UNIQUE using index "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."realtime_active_sessions" add constraint "rt_active_nokhte_sessions_secondary_speaker_spotlight_fkey" FOREIGN KEY (secondary_speaker_spotlight) REFERENCES auth.users(id) not valid;

alter table "public"."realtime_active_sessions" validate constraint "rt_active_nokhte_sessions_secondary_speaker_spotlight_fkey";

alter table "public"."realtime_active_sessions" add constraint "rt_active_nokhte_sessions_session_uid_fkey" FOREIGN KEY (session_uid) REFERENCES static_active_sessions(session_uid) not valid;

alter table "public"."realtime_active_sessions" validate constraint "rt_active_nokhte_sessions_session_uid_fkey";

alter table "public"."realtime_active_sessions" add constraint "rt_active_nokhte_sessions_speaker_spotlight_fkey" FOREIGN KEY (speaker_spotlight) REFERENCES auth.users(id) not valid;

alter table "public"."realtime_active_sessions" validate constraint "rt_active_nokhte_sessions_speaker_spotlight_fkey";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_duplicate_collaborator_uids_key" UNIQUE using index "st_active_nokhte_sessions_duplicate_collaborator_uids_key";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_duplicate_session_uid_key" UNIQUE using index "st_active_nokhte_sessions_duplicate_session_uid_key";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_leader_uid_fkey" FOREIGN KEY (leader_uid) REFERENCES auth.users(id) not valid;

alter table "public"."static_active_sessions" validate constraint "st_active_nokhte_sessions_leader_uid_fkey";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_leader_uid_key" UNIQUE using index "st_active_nokhte_sessions_leader_uid_key";

alter table "public"."static_active_sessions" add constraint "st_active_nokhte_sessions_preset_uid_fkey" FOREIGN KEY (preset_uid) REFERENCES company_presets(uid) not valid;

alter table "public"."static_active_sessions" validate constraint "st_active_nokhte_sessions_preset_uid_fkey";

alter table "public"."static_active_sessions" add constraint "static_active_sessions_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) not valid;

alter table "public"."static_active_sessions" validate constraint "static_active_sessions_group_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_group_member(p_user_uid uuid, p_group_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    group_members_array UUID[];
BEGIN
    -- Retrieve the group members for the specified group
    SELECT group_members INTO group_members_array
    FROM public.group_information
    WHERE uid = p_group_uid;

    -- Check if the user's UUID exists in the group members array
    RETURN p_user_uid = ANY(group_members_array);
EXCEPTION
    -- Handle cases where the group doesn't exist
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;$function$
;

grant delete on table "public"."finished_sessions" to "anon";

grant insert on table "public"."finished_sessions" to "anon";

grant references on table "public"."finished_sessions" to "anon";

grant select on table "public"."finished_sessions" to "anon";

grant trigger on table "public"."finished_sessions" to "anon";

grant truncate on table "public"."finished_sessions" to "anon";

grant update on table "public"."finished_sessions" to "anon";

grant delete on table "public"."finished_sessions" to "authenticated";

grant insert on table "public"."finished_sessions" to "authenticated";

grant references on table "public"."finished_sessions" to "authenticated";

grant select on table "public"."finished_sessions" to "authenticated";

grant trigger on table "public"."finished_sessions" to "authenticated";

grant truncate on table "public"."finished_sessions" to "authenticated";

grant update on table "public"."finished_sessions" to "authenticated";

grant delete on table "public"."finished_sessions" to "service_role";

grant insert on table "public"."finished_sessions" to "service_role";

grant references on table "public"."finished_sessions" to "service_role";

grant select on table "public"."finished_sessions" to "service_role";

grant trigger on table "public"."finished_sessions" to "service_role";

grant truncate on table "public"."finished_sessions" to "service_role";

grant update on table "public"."finished_sessions" to "service_role";

grant delete on table "public"."realtime_active_sessions" to "anon";

grant insert on table "public"."realtime_active_sessions" to "anon";

grant references on table "public"."realtime_active_sessions" to "anon";

grant select on table "public"."realtime_active_sessions" to "anon";

grant trigger on table "public"."realtime_active_sessions" to "anon";

grant truncate on table "public"."realtime_active_sessions" to "anon";

grant update on table "public"."realtime_active_sessions" to "anon";

grant delete on table "public"."realtime_active_sessions" to "authenticated";

grant insert on table "public"."realtime_active_sessions" to "authenticated";

grant references on table "public"."realtime_active_sessions" to "authenticated";

grant select on table "public"."realtime_active_sessions" to "authenticated";

grant trigger on table "public"."realtime_active_sessions" to "authenticated";

grant truncate on table "public"."realtime_active_sessions" to "authenticated";

grant update on table "public"."realtime_active_sessions" to "authenticated";

grant delete on table "public"."realtime_active_sessions" to "service_role";

grant insert on table "public"."realtime_active_sessions" to "service_role";

grant references on table "public"."realtime_active_sessions" to "service_role";

grant select on table "public"."realtime_active_sessions" to "service_role";

grant trigger on table "public"."realtime_active_sessions" to "service_role";

grant truncate on table "public"."realtime_active_sessions" to "service_role";

grant update on table "public"."realtime_active_sessions" to "service_role";

grant delete on table "public"."static_active_sessions" to "anon";

grant insert on table "public"."static_active_sessions" to "anon";

grant references on table "public"."static_active_sessions" to "anon";

grant select on table "public"."static_active_sessions" to "anon";

grant trigger on table "public"."static_active_sessions" to "anon";

grant truncate on table "public"."static_active_sessions" to "anon";

grant update on table "public"."static_active_sessions" to "anon";

grant delete on table "public"."static_active_sessions" to "authenticated";

grant insert on table "public"."static_active_sessions" to "authenticated";

grant references on table "public"."static_active_sessions" to "authenticated";

grant select on table "public"."static_active_sessions" to "authenticated";

grant trigger on table "public"."static_active_sessions" to "authenticated";

grant truncate on table "public"."static_active_sessions" to "authenticated";

grant update on table "public"."static_active_sessions" to "authenticated";

grant delete on table "public"."static_active_sessions" to "service_role";

grant insert on table "public"."static_active_sessions" to "service_role";

grant references on table "public"."static_active_sessions" to "service_role";

grant select on table "public"."static_active_sessions" to "service_role";

grant trigger on table "public"."static_active_sessions" to "service_role";

grant truncate on table "public"."static_active_sessions" to "service_role";

grant update on table "public"."static_active_sessions" to "service_role";

create policy "can read if is a group member"
on "public"."finished_sessions"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "INSERT: can insert row if leader of their session"
on "public"."realtime_active_sessions"
as permissive
for insert
to authenticated
with check ((EXISTS ( SELECT static_active_sessions.collaborator_uids
   FROM static_active_sessions
  WHERE ((realtime_active_sessions.session_uid = static_active_sessions.session_uid) AND (auth.uid() = static_active_sessions.leader_uid)))));


create policy "SELECT: They can read their own row"
on "public"."realtime_active_sessions"
as permissive
for select
to authenticated
using ((EXISTS ( SELECT static_active_sessions.collaborator_uids
   FROM static_active_sessions
  WHERE (realtime_active_sessions.session_uid = static_active_sessions.session_uid))));


create policy "UPDATE: They can update their row if is a valid session"
on "public"."realtime_active_sessions"
as permissive
for update
to authenticated
using ((EXISTS ( SELECT static_active_sessions.collaborator_uids
   FROM static_active_sessions
  WHERE (realtime_active_sessions.session_uid = static_active_sessions.session_uid))))
with check (true);


create policy "SELECT: They can read their row"
on "public"."static_active_sessions"
as permissive
for select
to authenticated
using ((auth.uid() = ANY (collaborator_uids)));


create policy "UPDATE: Can update valid rows"
on "public"."static_active_sessions"
as permissive
for update
to authenticated
using ((auth.uid() = ANY (collaborator_uids)))
with check (true);


create policy "can insert a row if they are the leader"
on "public"."static_active_sessions"
as permissive
for insert
to authenticated
with check (((leader_uid = auth.uid()) AND (auth.uid() = ANY (collaborator_uids))));
