create type "public"."document_type" as enum ('evergreen', 'ephemeral');

drop policy "Can Delete if Is a Group Member" on "public"."session_content";

drop policy "Can Update if Is a Group Member" on "public"."session_content";

drop policy "Enable insert for authenticated users only" on "public"."session_content";

drop policy "can select if is a member" on "public"."session_content";

drop policy "Anyone Can Insert a Row" on "public"."session_information";

drop policy "Can Delete if Is a Group Member" on "public"."session_information";

drop policy "Can Read if Is a Group Member" on "public"."session_information";

drop policy "Can Update if Is a Group Member" on "public"."session_information";

revoke delete on table "public"."session_content" from "anon";

revoke insert on table "public"."session_content" from "anon";

revoke references on table "public"."session_content" from "anon";

revoke select on table "public"."session_content" from "anon";

revoke trigger on table "public"."session_content" from "anon";

revoke truncate on table "public"."session_content" from "anon";

revoke update on table "public"."session_content" from "anon";

revoke delete on table "public"."session_content" from "authenticated";

revoke insert on table "public"."session_content" from "authenticated";

revoke references on table "public"."session_content" from "authenticated";

revoke select on table "public"."session_content" from "authenticated";

revoke trigger on table "public"."session_content" from "authenticated";

revoke truncate on table "public"."session_content" from "authenticated";

revoke update on table "public"."session_content" from "authenticated";

revoke delete on table "public"."session_content" from "service_role";

revoke insert on table "public"."session_content" from "service_role";

revoke references on table "public"."session_content" from "service_role";

revoke select on table "public"."session_content" from "service_role";

revoke trigger on table "public"."session_content" from "service_role";

revoke truncate on table "public"."session_content" from "service_role";

revoke update on table "public"."session_content" from "service_role";

revoke delete on table "public"."session_information" from "anon";

revoke insert on table "public"."session_information" from "anon";

revoke references on table "public"."session_information" from "anon";

revoke select on table "public"."session_information" from "anon";

revoke trigger on table "public"."session_information" from "anon";

revoke truncate on table "public"."session_information" from "anon";

revoke update on table "public"."session_information" from "anon";

revoke delete on table "public"."session_information" from "authenticated";

revoke insert on table "public"."session_information" from "authenticated";

revoke references on table "public"."session_information" from "authenticated";

revoke select on table "public"."session_information" from "authenticated";

revoke trigger on table "public"."session_information" from "authenticated";

revoke truncate on table "public"."session_information" from "authenticated";

revoke update on table "public"."session_information" from "authenticated";

revoke delete on table "public"."session_information" from "service_role";

revoke insert on table "public"."session_information" from "service_role";

revoke references on table "public"."session_information" from "service_role";

revoke select on table "public"."session_information" from "service_role";

revoke trigger on table "public"."session_information" from "service_role";

revoke truncate on table "public"."session_information" from "service_role";

revoke update on table "public"."session_information" from "service_role";

alter table "public"."session_content" drop constraint "session_content_parent_uid_fkey";

alter table "public"."session_content" drop constraint "session_content_session_uid_fkey";

alter table "public"."session_content" drop constraint "session_content_uid_key";

alter table "public"."session_information" drop constraint "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."session_information" drop constraint "session_information_group_uid_fkey";

alter table "public"."session_information" drop constraint "session_information_secondary_speaker_spotlight_fkey";

alter table "public"."session_information" drop constraint "session_information_speaker_spotlight_fkey";

alter table "public"."session_content" drop constraint "session_content_pkey";

alter table "public"."session_information" drop constraint "rt_active_nokhte_sessions_pkey";

drop index if exists "public"."active_irl_nokhte_sessions_session_uid_key";

drop index if exists "public"."rt_active_nokhte_sessions_pkey";

drop index if exists "public"."session_content_pkey";

drop index if exists "public"."session_content_uid_key";

drop table "public"."session_content";


create table "public"."content_blocks" (
    "session_uid" uuid not null,
    "last_edited_at" timestamp with time zone not null default now(),
    "type" content_block_type not null,
    "content" text not null,
    "parent_uid" uuid,
    "uid" uuid not null default gen_random_uuid()
);


alter table "public"."content_blocks" enable row level security;

create table "public"."documents" (
    "uid" uuid not null default gen_random_uuid(),
    "title" text not null,
    "spotlight_content_uid" uuid,
    "type" document_type not null,
    "expiration_date" timestamp with time zone not null
);


alter table "public"."documents" enable row level security;

create table "public"."sessions" (
    "uid" uuid not null default gen_random_uuid(),
    "speaker_spotlight" uuid,
    "version" integer not null default 0,
    "secondary_speaker_spotlight" uuid,
    "speaking_timer_start" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "group_uid" uuid not null,
    "status" session_status not null default 'recruiting'::session_status,
    "title" text not null default ''::text,
    "collaborator_names" text[] not null,
    "collaborator_uids" uuid[] not null,
    "collaborator_statuses" session_user_status[] not null
);

INSERT INTO public.sessions (
    uid, speaker_spotlight, version, secondary_speaker_spotlight, 
    speaking_timer_start, created_at, group_uid, status, title, 
    collaborator_names, collaborator_uids, collaborator_statuses
)
SELECT 
    uid, speaker_spotlight, version, secondary_speaker_spotlight, 
    speaking_timer_start, created_at, group_uid, status, title, 
    collaborator_names, collaborator_uids, collaborator_statuses
FROM public.session_information;

drop table "public"."session_information";


alter table "public"."sessions" enable row level security;

CREATE UNIQUE INDEX documents_pkey ON public.documents USING btree (uid);

CREATE UNIQUE INDEX active_irl_nokhte_sessions_session_uid_key ON public.sessions USING btree (uid);

CREATE UNIQUE INDEX rt_active_nokhte_sessions_pkey ON public.sessions USING btree (uid);

CREATE UNIQUE INDEX session_content_pkey ON public.content_blocks USING btree (uid);

CREATE UNIQUE INDEX session_content_uid_key ON public.content_blocks USING btree (uid);

alter table "public"."content_blocks" add constraint "session_content_pkey" PRIMARY KEY using index "session_content_pkey";

alter table "public"."documents" add constraint "documents_pkey" PRIMARY KEY using index "documents_pkey";

alter table "public"."sessions" add constraint "rt_active_nokhte_sessions_pkey" PRIMARY KEY using index "rt_active_nokhte_sessions_pkey";

alter table "public"."content_blocks" add constraint "session_content_parent_uid_fkey" FOREIGN KEY (parent_uid) REFERENCES content_blocks(uid) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."content_blocks" validate constraint "session_content_parent_uid_fkey";

alter table "public"."content_blocks" add constraint "session_content_session_uid_fkey" FOREIGN KEY (session_uid) REFERENCES sessions(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."content_blocks" validate constraint "session_content_session_uid_fkey";

alter table "public"."content_blocks" add constraint "session_content_uid_key" UNIQUE using index "session_content_uid_key";

alter table "public"."documents" add constraint "documents_spotlight_content_uid_fkey" FOREIGN KEY (spotlight_content_uid) REFERENCES content_blocks(uid) not valid;

alter table "public"."documents" validate constraint "documents_spotlight_content_uid_fkey";

alter table "public"."sessions" add constraint "active_irl_nokhte_sessions_session_uid_key" UNIQUE using index "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."sessions" add constraint "session_information_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sessions" validate constraint "session_information_group_uid_fkey";

alter table "public"."sessions" add constraint "session_information_secondary_speaker_spotlight_fkey" FOREIGN KEY (secondary_speaker_spotlight) REFERENCES user_information(uid) not valid;

alter table "public"."sessions" validate constraint "session_information_secondary_speaker_spotlight_fkey";

alter table "public"."sessions" add constraint "session_information_speaker_spotlight_fkey" FOREIGN KEY (speaker_spotlight) REFERENCES user_information(uid) not valid;

alter table "public"."sessions" validate constraint "session_information_speaker_spotlight_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.cleanup_expired_documents()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    deleted_count INTEGER;
BEGIN
    -- Delete expired documents and get count of deleted rows
    WITH deleted AS (
        DELETE FROM public.documents
        WHERE expiration_date < CURRENT_TIMESTAMP
        RETURNING uid
    )
    SELECT COUNT(*) INTO deleted_count
    FROM deleted;

    -- Log the cleanup operation
    INSERT INTO cron.job_run_details (jobid, runstatus, start_time, end_time, message)
    SELECT 
        job.jobid,
        'succeeded',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        format('Cleaned up %s expired documents', deleted_count)
    FROM cron.job
    WHERE command = 'SELECT cleanup_expired_documents()'
    ORDER BY jobid DESC
    LIMIT 1;
END;
$function$
;

grant delete on table "public"."content_blocks" to "anon";

grant insert on table "public"."content_blocks" to "anon";

grant references on table "public"."content_blocks" to "anon";

grant select on table "public"."content_blocks" to "anon";

grant trigger on table "public"."content_blocks" to "anon";

grant truncate on table "public"."content_blocks" to "anon";

grant update on table "public"."content_blocks" to "anon";

grant delete on table "public"."content_blocks" to "authenticated";

grant insert on table "public"."content_blocks" to "authenticated";

grant references on table "public"."content_blocks" to "authenticated";

grant select on table "public"."content_blocks" to "authenticated";

grant trigger on table "public"."content_blocks" to "authenticated";

grant truncate on table "public"."content_blocks" to "authenticated";

grant update on table "public"."content_blocks" to "authenticated";

grant delete on table "public"."content_blocks" to "service_role";

grant insert on table "public"."content_blocks" to "service_role";

grant references on table "public"."content_blocks" to "service_role";

grant select on table "public"."content_blocks" to "service_role";

grant trigger on table "public"."content_blocks" to "service_role";

grant truncate on table "public"."content_blocks" to "service_role";

grant update on table "public"."content_blocks" to "service_role";

grant delete on table "public"."documents" to "anon";

grant insert on table "public"."documents" to "anon";

grant references on table "public"."documents" to "anon";

grant select on table "public"."documents" to "anon";

grant trigger on table "public"."documents" to "anon";

grant truncate on table "public"."documents" to "anon";

grant update on table "public"."documents" to "anon";

grant delete on table "public"."documents" to "authenticated";

grant insert on table "public"."documents" to "authenticated";

grant references on table "public"."documents" to "authenticated";

grant select on table "public"."documents" to "authenticated";

grant trigger on table "public"."documents" to "authenticated";

grant truncate on table "public"."documents" to "authenticated";

grant update on table "public"."documents" to "authenticated";

grant delete on table "public"."documents" to "service_role";

grant insert on table "public"."documents" to "service_role";

grant references on table "public"."documents" to "service_role";

grant select on table "public"."documents" to "service_role";

grant trigger on table "public"."documents" to "service_role";

grant truncate on table "public"."documents" to "service_role";

grant update on table "public"."documents" to "service_role";

grant delete on table "public"."sessions" to "anon";

grant insert on table "public"."sessions" to "anon";

grant references on table "public"."sessions" to "anon";

grant select on table "public"."sessions" to "anon";

grant trigger on table "public"."sessions" to "anon";

grant truncate on table "public"."sessions" to "anon";

grant update on table "public"."sessions" to "anon";

grant delete on table "public"."sessions" to "authenticated";

grant insert on table "public"."sessions" to "authenticated";

grant references on table "public"."sessions" to "authenticated";

grant select on table "public"."sessions" to "authenticated";

grant trigger on table "public"."sessions" to "authenticated";

grant truncate on table "public"."sessions" to "authenticated";

grant update on table "public"."sessions" to "authenticated";

grant delete on table "public"."sessions" to "service_role";

grant insert on table "public"."sessions" to "service_role";

grant references on table "public"."sessions" to "service_role";

grant select on table "public"."sessions" to "service_role";

grant trigger on table "public"."sessions" to "service_role";

grant truncate on table "public"."sessions" to "service_role";

grant update on table "public"."sessions" to "service_role";

create policy "Can Delete if Is a Group Member"
on "public"."content_blocks"
as permissive
for delete
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));


create policy "Can Update if Is a Group Member"
on "public"."content_blocks"
as permissive
for update
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));


create policy "Enable insert for authenticated users only"
on "public"."content_blocks"
as permissive
for insert
to authenticated
with check (true);


create policy "can select if is a member"
on "public"."content_blocks"
as permissive
for select
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));


create policy "Anyone Can Insert a Row"
on "public"."sessions"
as permissive
for insert
to authenticated
with check (is_group_member(auth.uid(), group_uid));


create policy "Can Delete if Is a Group Member"
on "public"."sessions"
as permissive
for delete
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Read if Is a Group Member"
on "public"."sessions"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Update if Is a Group Member"
on "public"."sessions"
as permissive
for update
to authenticated
using (is_group_member(auth.uid(), group_uid));

CREATE OR REPLACE FUNCTION public.cleanup_expired_documents()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    -- Delete expired documents and get count of deleted rows
    WITH deleted AS (
        DELETE FROM public.documents
        WHERE expiration_date < CURRENT_TIMESTAMP
        RETURNING uid
    )
    SELECT COUNT(*) INTO deleted_count
    FROM deleted;

    -- Log the cleanup operation
    INSERT INTO cron.job_run_details (jobid, runstatus, start_time, end_time, message)
    SELECT 
        job.jobid,
        'succeeded',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        format('Cleaned up %s expired documents', deleted_count)
    FROM cron.job
    WHERE command = 'SELECT public.cleanup_expired_documents()'
    ORDER BY jobid DESC
    LIMIT 1;
END;
$$;

CREATE EXTENSION IF NOT EXISTS pg_cron;


-- Schedule the job to run daily at midnight
SELECT cron.schedule(
    'cleanup-expired-documents',           -- job name
    '0 0 * * *',                          -- cron schedule (midnight every day)
    'SELECT public.cleanup_expired_documents()'   -- SQL command to execute
);


drop policy "Can Delete Relationship If They Are a Collaborator" on "public"."collaborator_relationships";

drop policy "Can Insert Relationship As a Collaborator" on "public"."collaborator_relationships";

drop policy "Can View Relationship" on "public"."collaborator_relationships";

drop policy "Can Create Requests With Basic Limitations" on "public"."collaborator_requests";

drop policy "Can Delete Requests if They Are a Sender or a Recipient" on "public"."collaborator_requests";

drop policy "Can Only Update if They Are a Recipient" on "public"."collaborator_requests";

drop policy "Can See Requests if They Are a Recipient or a Sender" on "public"."collaborator_requests";

drop policy "Broad Permissions if They Are a Group Member" on "public"."group_information";

drop policy "CREATE: Users Who Don't Have a Row Already Can Add Theirs" on "public"."user_information";

drop policy "Can Read: If Is An Friend Or Owner" on "public"."user_information";

drop policy "UPDATE: Users can update their own row" on "public"."user_information";

revoke delete on table "public"."collaborator_relationships" from "anon";

revoke insert on table "public"."collaborator_relationships" from "anon";

revoke references on table "public"."collaborator_relationships" from "anon";

revoke select on table "public"."collaborator_relationships" from "anon";

revoke trigger on table "public"."collaborator_relationships" from "anon";

revoke truncate on table "public"."collaborator_relationships" from "anon";

revoke update on table "public"."collaborator_relationships" from "anon";

revoke delete on table "public"."collaborator_relationships" from "authenticated";

revoke insert on table "public"."collaborator_relationships" from "authenticated";

revoke references on table "public"."collaborator_relationships" from "authenticated";

revoke select on table "public"."collaborator_relationships" from "authenticated";

revoke trigger on table "public"."collaborator_relationships" from "authenticated";

revoke truncate on table "public"."collaborator_relationships" from "authenticated";

revoke update on table "public"."collaborator_relationships" from "authenticated";

revoke delete on table "public"."collaborator_relationships" from "service_role";

revoke insert on table "public"."collaborator_relationships" from "service_role";

revoke references on table "public"."collaborator_relationships" from "service_role";

revoke select on table "public"."collaborator_relationships" from "service_role";

revoke trigger on table "public"."collaborator_relationships" from "service_role";

revoke truncate on table "public"."collaborator_relationships" from "service_role";

revoke update on table "public"."collaborator_relationships" from "service_role";

revoke delete on table "public"."collaborator_requests" from "anon";

revoke insert on table "public"."collaborator_requests" from "anon";

revoke references on table "public"."collaborator_requests" from "anon";

revoke select on table "public"."collaborator_requests" from "anon";

revoke trigger on table "public"."collaborator_requests" from "anon";

revoke truncate on table "public"."collaborator_requests" from "anon";

revoke update on table "public"."collaborator_requests" from "anon";

revoke delete on table "public"."collaborator_requests" from "authenticated";

revoke insert on table "public"."collaborator_requests" from "authenticated";

revoke references on table "public"."collaborator_requests" from "authenticated";

revoke select on table "public"."collaborator_requests" from "authenticated";

revoke trigger on table "public"."collaborator_requests" from "authenticated";

revoke truncate on table "public"."collaborator_requests" from "authenticated";

revoke update on table "public"."collaborator_requests" from "authenticated";

revoke delete on table "public"."collaborator_requests" from "service_role";

revoke insert on table "public"."collaborator_requests" from "service_role";

revoke references on table "public"."collaborator_requests" from "service_role";

revoke select on table "public"."collaborator_requests" from "service_role";

revoke trigger on table "public"."collaborator_requests" from "service_role";

revoke truncate on table "public"."collaborator_requests" from "service_role";

revoke update on table "public"."collaborator_requests" from "service_role";

revoke delete on table "public"."group_information" from "anon";

revoke insert on table "public"."group_information" from "anon";

revoke references on table "public"."group_information" from "anon";

revoke select on table "public"."group_information" from "anon";

revoke trigger on table "public"."group_information" from "anon";

revoke truncate on table "public"."group_information" from "anon";

revoke update on table "public"."group_information" from "anon";

revoke delete on table "public"."group_information" from "authenticated";

revoke insert on table "public"."group_information" from "authenticated";

revoke references on table "public"."group_information" from "authenticated";

revoke select on table "public"."group_information" from "authenticated";

revoke trigger on table "public"."group_information" from "authenticated";

revoke truncate on table "public"."group_information" from "authenticated";

revoke update on table "public"."group_information" from "authenticated";

revoke delete on table "public"."group_information" from "service_role";

revoke insert on table "public"."group_information" from "service_role";

revoke references on table "public"."group_information" from "service_role";

revoke select on table "public"."group_information" from "service_role";

revoke trigger on table "public"."group_information" from "service_role";

revoke truncate on table "public"."group_information" from "service_role";

revoke update on table "public"."group_information" from "service_role";

revoke delete on table "public"."user_information" from "anon";

revoke insert on table "public"."user_information" from "anon";

revoke references on table "public"."user_information" from "anon";

revoke select on table "public"."user_information" from "anon";

revoke trigger on table "public"."user_information" from "anon";

revoke truncate on table "public"."user_information" from "anon";

revoke update on table "public"."user_information" from "anon";

revoke delete on table "public"."user_information" from "authenticated";

revoke insert on table "public"."user_information" from "authenticated";

revoke references on table "public"."user_information" from "authenticated";

revoke select on table "public"."user_information" from "authenticated";

revoke trigger on table "public"."user_information" from "authenticated";

revoke truncate on table "public"."user_information" from "authenticated";

revoke update on table "public"."user_information" from "authenticated";

revoke delete on table "public"."user_information" from "service_role";

revoke insert on table "public"."user_information" from "service_role";

revoke references on table "public"."user_information" from "service_role";

revoke select on table "public"."user_information" from "service_role";

revoke trigger on table "public"."user_information" from "service_role";

revoke truncate on table "public"."user_information" from "service_role";

revoke update on table "public"."user_information" from "service_role";

alter table "public"."collaborator_relationships" drop constraint "collaborator_relationships_collaborator_one_uid_fkey";

alter table "public"."collaborator_relationships" drop constraint "collaborator_relationships_collaborator_two_uid_fkey";

alter table "public"."collaborator_requests" drop constraint "collaborator_requests_recipient_uid_fkey";

alter table "public"."collaborator_requests" drop constraint "collaborator_requests_sender_uid_fkey";

alter table "public"."collaborator_requests" drop constraint "unique_sender_recipient";

alter table "public"."group_information" drop constraint "group_information_group_handle_key";

alter table "public"."user_information" drop constraint "user_information_uid_check";

alter table "public"."user_information" drop constraint "user_information_uid_fkey";

alter table "public"."user_information" drop constraint "usernames_uid_key";

alter table "public"."sessions" drop constraint "session_information_group_uid_fkey";

alter table "public"."sessions" drop constraint "session_information_secondary_speaker_spotlight_fkey";

alter table "public"."sessions" drop constraint "session_information_speaker_spotlight_fkey";

alter table "public"."collaborator_relationships" drop constraint "collaborator_relationships_pkey";

alter table "public"."collaborator_requests" drop constraint "collaborator_requests_pkey";

alter table "public"."group_information" drop constraint "group_information_pkey";

alter table "public"."user_information" drop constraint "usernames_pkey";

drop index if exists "public"."collaborator_relationships_pkey";

drop index if exists "public"."collaborator_requests_pkey";

drop index if exists "public"."idx_unique_collaborator_relationship";

drop index if exists "public"."unique_sender_recipient";

drop index if exists "public"."group_information_group_handle_key";

drop index if exists "public"."group_information_pkey";

drop index if exists "public"."usernames_pkey";

drop index if exists "public"."usernames_uid_key";

drop table "public"."collaborator_relationships";

drop table "public"."collaborator_requests";



create table "public"."groups" (
    "uid" uuid not null default gen_random_uuid(),
    "group_members" uuid[] not null,
    "group_name" text not null,
    "group_handle" text not null
);

INSERT INTO public.groups (uid, group_members, group_name, group_handle)
SELECT uid, group_members, group_name, group_handle
FROM public.group_information;



drop table "public"."group_information";

alter table "public"."groups" enable row level security;

create table "public"."users" (
    "uid" uuid not null,
    "first_name" text,
    "last_name" text
);

INSERT INTO public.users (uid, first_name, last_name)
SELECT uid, first_name, last_name
FROM public.user_information;



drop table "public"."user_information";


alter table "public"."users" enable row level security;

CREATE UNIQUE INDEX group_information_group_handle_key ON public.groups USING btree (group_handle);

CREATE UNIQUE INDEX group_information_pkey ON public.groups USING btree (uid);

CREATE UNIQUE INDEX usernames_pkey ON public.users USING btree (uid);

CREATE UNIQUE INDEX usernames_uid_key ON public.users USING btree (uid);

alter table "public"."groups" add constraint "group_information_pkey" PRIMARY KEY using index "group_information_pkey";

alter table "public"."users" add constraint "usernames_pkey" PRIMARY KEY using index "usernames_pkey";

alter table "public"."groups" add constraint "group_information_group_handle_key" UNIQUE using index "group_information_group_handle_key";

alter table "public"."users" add constraint "user_information_uid_check" CHECK ((auth.uid() = uid)) not valid;

alter table "public"."users" validate constraint "user_information_uid_check";

alter table "public"."users" add constraint "user_information_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) not valid;

alter table "public"."users" validate constraint "user_information_uid_fkey";

alter table "public"."users" add constraint "usernames_uid_key" UNIQUE using index "usernames_uid_key";

alter table "public"."sessions" add constraint "session_information_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES groups(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sessions" validate constraint "session_information_group_uid_fkey";

alter table "public"."sessions" add constraint "session_information_secondary_speaker_spotlight_fkey" FOREIGN KEY (secondary_speaker_spotlight) REFERENCES users(uid) not valid;

alter table "public"."sessions" validate constraint "session_information_secondary_speaker_spotlight_fkey";

alter table "public"."sessions" add constraint "session_information_speaker_spotlight_fkey" FOREIGN KEY (speaker_spotlight) REFERENCES users(uid) not valid;

alter table "public"."sessions" validate constraint "session_information_speaker_spotlight_fkey";

grant delete on table "public"."groups" to "anon";

grant insert on table "public"."groups" to "anon";

grant references on table "public"."groups" to "anon";

grant select on table "public"."groups" to "anon";

grant trigger on table "public"."groups" to "anon";

grant truncate on table "public"."groups" to "anon";

grant update on table "public"."groups" to "anon";

grant delete on table "public"."groups" to "authenticated";

grant insert on table "public"."groups" to "authenticated";

grant references on table "public"."groups" to "authenticated";

grant select on table "public"."groups" to "authenticated";

grant trigger on table "public"."groups" to "authenticated";

grant truncate on table "public"."groups" to "authenticated";

grant update on table "public"."groups" to "authenticated";

grant delete on table "public"."groups" to "service_role";

grant insert on table "public"."groups" to "service_role";

grant references on table "public"."groups" to "service_role";

grant select on table "public"."groups" to "service_role";

grant trigger on table "public"."groups" to "service_role";

grant truncate on table "public"."groups" to "service_role";

grant update on table "public"."groups" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

create policy "Broad Permissions if They Are a Group Member"
on "public"."groups"
as permissive
for all
to authenticated
using ((auth.uid() = ANY (group_members)));


create policy "CREATE: Users Who Don't Have a Row Already Can Add Theirs"
on "public"."users"
as permissive
for insert
to authenticated
with check ((NOT (EXISTS ( SELECT 1
   FROM users usernames_1
  WHERE (auth.uid() = usernames_1.uid)))));


create policy "Can Read: If Is An Friend Or Owner"
on "public"."users"
as permissive
for select
to authenticated
using (((uid = auth.uid()) OR are_collaborators(auth.uid(), uid)));


create policy "UPDATE: Users can update their own row"
on "public"."users"
as permissive
for update
to authenticated
using ((uid = auth.uid()))
with check (true);


alter publication supabase_realtime
add
    table public.content_blocks;

alter publication supabase_realtime
add
    table public.documents;

alter publication supabase_realtime
add
    table public.sessions;
    
    
alter table "public"."content_blocks" replica identity full;
alter table "public"."sessions" replica identity full;
alter table "public"."documents" replica identity full;
alter table "public"."groups" replica identity full;

drop policy "Can Read: If Is An Friend Or Owner" on "public"."users";

drop policy "Can Delete if Is a Group Member" on "public"."content_blocks";

drop policy "Can Update if Is a Group Member" on "public"."content_blocks";

drop policy "can select if is a member" on "public"."content_blocks";

alter table "public"."content_blocks" drop constraint "session_content_session_uid_fkey";

alter table "public"."content_blocks" drop column "session_uid";

alter table "public"."content_blocks" add column "document_uid" uuid not null;

alter table "public"."content_blocks" add constraint "content_blocks_document_uid_fkey" FOREIGN KEY (document_uid) REFERENCES documents(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_document_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.have_common_group(user_uid_1 uuid, user_uid_2 uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM public.groups g
        WHERE user_uid_1 = ANY(g.group_members)
          AND user_uid_2 = ANY(g.group_members)
    );
END;
$function$
;

create policy "Can Read: If Is An Friend Or Have Common Groups"
on "public"."users"
as permissive
for select
to authenticated
using (((uid = auth.uid()) OR have_common_group(auth.uid(), uid)));


create policy "Can Delete if Is a Group Member"
on "public"."content_blocks"
as permissive
for delete
to authenticated
using (check_membership_from_session_uid(document_uid, auth.uid()));


create policy "Can Update if Is a Group Member"
on "public"."content_blocks"
as permissive
for update
to authenticated
using (check_membership_from_session_uid(document_uid, auth.uid()));


create policy "can select if is a member"
on "public"."content_blocks"
as permissive
for select
to authenticated
using (check_membership_from_session_uid(document_uid, auth.uid()));

