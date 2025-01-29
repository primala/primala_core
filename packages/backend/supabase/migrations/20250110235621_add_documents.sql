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

create type "public"."group_permission" as enum ('groups.update', 'groups.delete', 'groups.select');

create type "public"."group_role" as enum ('admin', 'collaborator');

drop policy "Can Delete if Is a Group Member" on "public"."content_blocks";

drop policy "Can Update if Is a Group Member" on "public"."content_blocks";

drop policy "can select if is a member" on "public"."content_blocks";

alter table "public"."groups" drop constraint "group_information_group_handle_key";

drop index if exists "public"."group_information_group_handle_key";

create table "public"."group_roles" (
    "id" bigint generated by default as identity not null,
    "user_uid" uuid not null,
    "role" group_role not null,
    "group_uid" uuid
);


alter table "public"."group_roles" enable row level security;

alter table "public"."groups" drop column "group_handle";

CREATE UNIQUE INDEX group_roles_pkey ON public.group_roles USING btree (id);

CREATE UNIQUE INDEX group_roles_user_group_unique ON public.group_roles USING btree (user_uid, group_uid);


alter table "public"."group_roles" add constraint "group_roles_pkey" PRIMARY KEY using index "group_roles_pkey";


alter table "public"."group_roles" add constraint "group_roles_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES groups(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group_roles" validate constraint "group_roles_group_uid_fkey";

alter table "public"."group_roles" add constraint "group_roles_user_group_unique" UNIQUE using index "group_roles_user_group_unique";

alter table "public"."group_roles" add constraint "group_roles_user_uid_fkey" FOREIGN KEY (user_uid) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group_roles" validate constraint "group_roles_user_uid_fkey";


set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.has_content_block_access(user_uid uuid, content_block_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
declare
    document_uid uuid;
    group_uid uuid;
begin
    -- Find the document UID for the content block
    select document_uid into document_uid
    from public.content_blocks
    where uid = content_block_uid;

    -- Ensure a valid document UID was found
    if document_uid is null then
        return false;
    end if;

    -- Find the group UID associated with the document
    select groups.uid into group_uid
    from public.documents
    join public.groups on groups.uid = any(groups.group_members)
    where documents.uid = document_uid;

    -- Check if the user is part of the group
    return exists (
        select 1
        from public.groups
        where uid = group_uid
        and user_uid = any(group_members)
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.has_document_access(user_uid uuid, document_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
declare
    group_uid uuid;
begin
    -- Find the group UID associated with the document
    select groups.uid into group_uid
    from public.documents
    join public.groups on groups.uid = any(groups.group_members)
    where documents.uid = document_uid;

    -- Ensure a valid group UID was found
    if group_uid is null then
        return false;
    end if;

    -- Check if the user is part of the group
    return exists (
        select 1
        from public.groups
        where uid = group_uid
        and user_uid = any(group_members)
    );
end;
$function$
;

grant delete on table "public"."group_roles" to "anon";

grant insert on table "public"."group_roles" to "anon";

grant references on table "public"."group_roles" to "anon";

grant select on table "public"."group_roles" to "anon";

grant trigger on table "public"."group_roles" to "anon";

grant truncate on table "public"."group_roles" to "anon";

grant update on table "public"."group_roles" to "anon";

grant delete on table "public"."group_roles" to "authenticated";

grant insert on table "public"."group_roles" to "authenticated";

grant references on table "public"."group_roles" to "authenticated";

grant select on table "public"."group_roles" to "authenticated";

grant trigger on table "public"."group_roles" to "authenticated";

grant truncate on table "public"."group_roles" to "authenticated";

grant update on table "public"."group_roles" to "authenticated";

grant delete on table "public"."group_roles" to "service_role";

grant insert on table "public"."group_roles" to "service_role";

grant references on table "public"."group_roles" to "service_role";

grant select on table "public"."group_roles" to "service_role";

grant trigger on table "public"."group_roles" to "service_role";

grant truncate on table "public"."group_roles" to "service_role";

grant update on table "public"."group_roles" to "service_role";

create policy "Can Delete if has document access"
on "public"."content_blocks"
as permissive
for delete
to authenticated
using (has_content_block_access(auth.uid(), document_uid));


create policy "Can Update if has document access"
on "public"."content_blocks"
as permissive
for update
to authenticated
using (has_content_block_access(auth.uid(), document_uid));


create policy "can select if has document status"
on "public"."content_blocks"
as permissive
for select
to authenticated
using (has_content_block_access(auth.uid(), document_uid));

drop policy "Can Delete if has document access" on "public"."content_blocks";

drop policy "Can Update if has document access" on "public"."content_blocks";

drop policy "Enable insert for authenticated users only" on "public"."content_blocks";

drop policy "can select if has document status" on "public"."content_blocks";

drop policy "Broad Permissions if They Are a Group Member" on "public"."groups";

drop policy "Anyone Can Insert a Row" on "public"."sessions";

drop policy "Can Delete if Is a Group Member" on "public"."sessions";

drop policy "Can Read if Is a Group Member" on "public"."sessions";

drop policy "Can Update if Is a Group Member" on "public"."sessions";

drop policy "Can Read: If Is An Friend Or Have Common Groups" on "public"."users";

drop function if exists "public"."are_collaborators"(check_uid uuid, target_uid uuid);

drop function if exists "public"."check_membership_from_session_uid"(session_uid_param uuid, user_uid_param uuid);

drop function if exists "public"."has_content_block_access"(user_uid uuid, content_block_uid uuid);

drop function if exists "public"."has_document_access"(user_uid uuid, document_uid uuid);

drop function if exists "public"."have_common_group"(user_uid_1 uuid, user_uid_2 uuid);

drop function if exists "public"."is_group_member"(p_user_uid uuid, p_group_uid uuid);


drop index if exists "public"."role_permission_unique";

drop index if exists "public"."rolle_permissions_pkey";

alter table "public"."content_blocks" add column "group_uid" uuid not null;

alter table "public"."documents" add column "group_uid" uuid not null;

alter table "public"."groups" drop column "group_members";

alter table "public"."groups" add column "creator_uid" uuid not null default auth.uid();

drop type "public"."group_permission";

alter table "public"."content_blocks" add constraint "content_blocks_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES groups(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_group_uid_fkey";

alter table "public"."documents" add constraint "documents_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES groups(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."documents" validate constraint "documents_group_uid_fkey";

alter table "public"."groups" add constraint "groups_creator_uid_fkey" FOREIGN KEY (creator_uid) REFERENCES users(uid) ON UPDATE CASCADE not valid;

alter table "public"."groups" validate constraint "groups_creator_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_group_admin(user_uid uuid, group_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 and group_uid = $2 and role = 'admin'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_collaborator(user_uid uuid, group_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 and group_uid = $2 and role = 'collaborator'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_creator(user_uid uuid, group_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.groups
        where creator_uid = $1 and uid = $2
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_member(user_uid uuid, group_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 and group_uid = $2
    );
end;
$function$
;

create policy "Enables Broad Permissions if Is a Group Member"
on "public"."content_blocks"
as permissive
for select
to public
using (is_group_member(auth.uid(), group_uid));


create policy "Enables Broad Permissions if Is a Group Member"
on "public"."documents"
as permissive
for all
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Insert if Is Group Creator or an Admin"
on "public"."group_roles"
as permissive
for insert
to authenticated
with check ((is_group_admin(auth.uid(), group_uid) OR is_group_creator(auth.uid(), group_uid)));


create policy "Can Read if Is a Group Member"
on "public"."group_roles"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Update if Is Group Admin"
on "public"."group_roles"
as permissive
for update
to authenticated
using (is_group_admin(auth.uid(), group_uid));


create policy "Can Only Update if Is Group Admin"
on "public"."groups"
as permissive
for update
to authenticated
using (is_group_admin(auth.uid(), uid));


create policy "Enable insert for authenticated users only"
on "public"."groups"
as permissive
for insert
to authenticated
with check ((auth.uid() = creator_uid));


create policy "Enabled Delete for Group Admins"
on "public"."groups"
as permissive
for delete
to public
using (is_group_admin(auth.uid(), uid));


create policy "Broad Permissions if Is a Group Member"
on "public"."sessions"
as permissive
for all
to public
using (is_group_member(auth.uid(), group_uid));


create policy "Can delete if Is Their Own Row or Is Group Admin"
on "public"."group_roles"
as permissive
for delete
to authenticated
using (((auth.uid() = user_uid) OR is_group_admin(auth.uid(), group_uid)));

drop policy "Enables Broad Permissions if Is a Group Member" on "public"."content_blocks";

drop policy "Enables Broad Permissions if Is a Group Member" on "public"."documents";

drop policy "Can Insert if Is Group Creator or an Admin" on "public"."group_roles";

drop policy "Can Read if Is a Group Member" on "public"."group_roles";

drop policy "Can Update if Is Group Admin" on "public"."group_roles";

drop policy "Can delete if Is Their Own Row or Is Group Admin" on "public"."group_roles";

drop policy "Can Only Update if Is Group Admin" on "public"."groups";

drop policy "Enabled Delete for Group Admins" on "public"."groups";

drop policy "Broad Permissions if Is a Group Member" on "public"."sessions";

alter table "public"."content_blocks" drop constraint "content_blocks_document_uid_fkey";

alter table "public"."content_blocks" drop constraint "content_blocks_group_uid_fkey";

alter table "public"."content_blocks" drop constraint "session_content_parent_uid_fkey";

alter table "public"."content_blocks" drop constraint "session_content_uid_key";

alter table "public"."documents" drop constraint "documents_group_uid_fkey";

alter table "public"."documents" drop constraint "documents_spotlight_content_uid_fkey";

alter table "public"."group_roles" drop constraint "group_roles_group_uid_fkey";

alter table "public"."group_roles" drop constraint "group_roles_user_group_unique";

alter table "public"."sessions" drop constraint "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."sessions" drop constraint "session_information_group_uid_fkey";

drop function if exists "public"."is_group_admin"(user_uid uuid, group_uid uuid);

drop function if exists "public"."is_group_collaborator"(user_uid uuid, group_uid uuid);

drop function if exists "public"."is_group_creator"(user_uid uuid, group_uid uuid);

drop function if exists "public"."is_group_member"(user_uid uuid, group_uid uuid);

alter table "public"."content_blocks" drop constraint "session_content_pkey";

alter table "public"."groups" drop constraint "group_information_pkey";

alter table "public"."sessions" drop constraint "rt_active_nokhte_sessions_pkey";

alter table "public"."documents" drop constraint "documents_pkey";

drop index if exists "public"."active_irl_nokhte_sessions_session_uid_key";

drop index if exists "public"."group_information_pkey";

drop index if exists "public"."group_roles_user_group_unique";

drop index if exists "public"."rt_active_nokhte_sessions_pkey";

drop index if exists "public"."session_content_pkey";

drop index if exists "public"."session_content_uid_key";

drop index if exists "public"."documents_pkey";

alter table "public"."content_blocks" drop column "document_uid";

alter table "public"."content_blocks" drop column "group_uid";

alter table "public"."content_blocks" drop column "parent_uid";

alter table "public"."content_blocks" drop column "uid";

alter table "public"."content_blocks" add column "document_id" bigint not null;

alter table "public"."content_blocks" add column "group_id" bigint;

alter table "public"."content_blocks" add column "id" bigint generated by default as identity not null;

alter table "public"."content_blocks" add column "parent_id" bigint;

alter table "public"."documents" drop column "group_uid";

alter table "public"."documents" drop column "spotlight_content_uid";

alter table "public"."documents" drop column "uid";

alter table "public"."documents" add column "group_id" bigint not null;

alter table "public"."documents" add column "id" bigint generated by default as identity not null;

alter table "public"."documents" add column "spotlight_content_id" bigint;

alter table "public"."group_roles" drop column "group_uid";

alter table "public"."group_roles" add column "group_id" bigint not null;

alter table "public"."groups" drop column "uid";

alter table "public"."groups" add column "id" bigint generated by default as identity not null;

alter table "public"."sessions" drop column "group_uid";

alter table "public"."sessions" drop column "uid";

alter table "public"."sessions" add column "group_id" bigint;

alter table "public"."sessions" add column "id" bigint generated by default as identity not null;

CREATE UNIQUE INDEX content_blocks_pkey ON public.content_blocks USING btree (id);

CREATE UNIQUE INDEX groups_pkey ON public.groups USING btree (id);

CREATE UNIQUE INDEX sessions_pkey ON public.sessions USING btree (id);

CREATE UNIQUE INDEX documents_pkey ON public.documents USING btree (id);

alter table "public"."content_blocks" add constraint "content_blocks_pkey" PRIMARY KEY using index "content_blocks_pkey";

alter table "public"."groups" add constraint "groups_pkey" PRIMARY KEY using index "groups_pkey";

alter table "public"."sessions" add constraint "sessions_pkey" PRIMARY KEY using index "sessions_pkey";

alter table "public"."documents" add constraint "documents_pkey" PRIMARY KEY using index "documents_pkey";

alter table "public"."content_blocks" add constraint "content_blocks_document_id_fkey" FOREIGN KEY (document_id) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_document_id_fkey";

alter table "public"."content_blocks" add constraint "content_blocks_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_group_id_fkey";

alter table "public"."content_blocks" add constraint "content_blocks_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES content_blocks(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_parent_id_fkey";

alter table "public"."documents" add constraint "documents_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."documents" validate constraint "documents_group_id_fkey";

alter table "public"."documents" add constraint "documents_spotlight_content_id_fkey" FOREIGN KEY (spotlight_content_id) REFERENCES content_blocks(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."documents" validate constraint "documents_spotlight_content_id_fkey";

alter table "public"."group_roles" add constraint "group_roles_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group_roles" validate constraint "group_roles_group_id_fkey";

alter table "public"."sessions" add constraint "sessions_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sessions" validate constraint "sessions_group_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_group_admin(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2 
        and role = 'admin'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_collaborator(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2 
        and role = 'collaborator'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_creator(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.groups
        where creator_uid = $1 
        and id = $2
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_member(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2
    );
end;
$function$
;

create policy "Enables Broad Permissions if Is a Group Member"
on "public"."content_blocks"
as permissive
for select
to public
using (is_group_member(auth.uid(), group_id));


create policy "Enables Broad Permissions if Is a Group Member"
on "public"."documents"
as permissive
for all
to authenticated
using (is_group_member(auth.uid(), group_id));


create policy "Can Insert if Is Group Creator or an Admin"
on "public"."group_roles"
as permissive
for insert
to authenticated
with check ((is_group_admin(auth.uid(), group_id) OR is_group_creator(auth.uid(), group_id)));


create policy "Can Read if Is a Group Member"
on "public"."group_roles"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), group_id));


create policy "Can Update if Is Group Admin"
on "public"."group_roles"
as permissive
for update
to authenticated
using (is_group_admin(auth.uid(), group_id));


create policy "Can delete if Is Their Own Row or Is Group Admin"
on "public"."group_roles"
as permissive
for delete
to authenticated
using (((auth.uid() = user_uid) OR is_group_admin(auth.uid(), group_id)));


create policy "Can Only Update if Is Group Admin"
on "public"."groups"
as permissive
for update
to authenticated
using (is_group_admin(auth.uid(), id));


create policy "Enabled Delete for Group Admins"
on "public"."groups"
as permissive
for delete
to public
using (is_group_admin(auth.uid(), id));


create policy "Broad Permissions if Is a Group Member"
on "public"."sessions"
as permissive
for all
to public
using (is_group_member(auth.uid(), group_id));

create policy "Can Select if Is a Group Member or Creator"
on "public"."groups"
as permissive
for insert
to public
with check (((auth.uid() = creator_uid) OR is_group_member(auth.uid(), id)));



drop policy "Can Select if Is a Group Member or Creator" on "public"."groups";

drop policy "Can Read if Is a Group Member" on "public"."group_roles";

drop policy "Enable insert for authenticated users only" on "public"."groups";

drop policy "Enabled Delete for Group Admins" on "public"."groups";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_group_admin(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2 
        and role = 'admin'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_collaborator(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2 
        and role = 'collaborator'
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_creator(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
    return exists (
        select 1
        from public.groups
        where creator_uid = $1 
        and id = $2
    );
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_group_member(_user_uid uuid, _group_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
    return exists (
        select 1
        from public.group_roles
        where user_uid = $1 
        and group_id = $2
    );
end;
$function$
;

create policy "Can Select if Is Group Creator or Group Member"
on "public"."groups"
as permissive
for select
to authenticated
using (((auth.uid() = creator_uid) OR is_group_member(auth.uid(), id)));


create policy "Can Read if Is a Group Member"
on "public"."group_roles"
as permissive
for select
to authenticated
using ((is_group_member(auth.uid(), group_id) OR (auth.uid() = user_uid)));


create policy "Enable insert for authenticated users only"
on "public"."groups"
as permissive
for insert
to authenticated
with check (true);


create policy "Enabled Delete for Group Admins"
on "public"."groups"
as permissive
for delete
to authenticated
using (is_group_admin(auth.uid(), id));

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_collaborator_status(incoming_session_id bigint, index_to_edit integer, new_status session_user_status)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
    update public.sessions SET collaborator_statuses[index_to_edit+1] = new_status WHERE id = incoming_session_id;
END;$function$
;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.join_session(_session_id bigint, _user_uid uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    _current_collaborator_uids uuid[];
    _current_collaborator_names text[];
    _current_collaborator_statuses session_user_status[];
    _current_version int4;
    _session_status session_status;
    _user_name text;
BEGIN
    -- Begin transaction
    BEGIN
        -- Retrieve session details from the session_information table
        SELECT 
            version,
            collaborator_uids,
            collaborator_names,
            collaborator_statuses,
            status
        INTO 
            _current_version,
            _current_collaborator_uids,
            _current_collaborator_names,
            _current_collaborator_statuses,
            _session_status
        FROM sessions
        WHERE id IN (
            SELECT id 
            FROM sessions 
            WHERE _session_id = id
        );

        IF _session_id IS NOT NULL THEN
            IF _user_uid = ANY(_current_collaborator_uids) THEN
                RETURN; -- Exit the function if user is already in the collaborator list
            END IF;

            IF _session_status = 'recruiting' THEN
                -- Get the user's name from the users table
                SELECT first_name || ' ' || last_name
                INTO _user_name
                FROM users
                WHERE uid = _user_uid;

                -- Append values to arrays
                _current_collaborator_uids := array_append(_current_collaborator_uids, _user_uid);
                _current_collaborator_names := array_append(_current_collaborator_names, _user_name);
                _current_collaborator_statuses := array_append(_current_collaborator_statuses, 'has_joined'::session_user_status);

                -- Increment version
                _current_version := _current_version + 1;

                -- Update sessions
                UPDATE public.sessions
                SET 
                    collaborator_uids = _current_collaborator_uids,
                    collaborator_names = _current_collaborator_names,
                    collaborator_statuses = _current_collaborator_statuses,
                    version = _current_version
                WHERE id = _session_id
                AND version = _current_version - 1; -- Optimistic locking condition

                -- Check if the update succeeded
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Update on sessions failed due to version mismatch';
                END IF;
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction if anything goes wrong
            RAISE NOTICE 'Transaction failed: %', SQLERRM;
            RAISE; -- Propagate the error
    END;
END;
$function$
;



alter table "public"."documents" add column "parent_document_id" bigint;

alter table "public"."sessions" drop column "created_at";

alter table "public"."sessions" drop column "title";

alter table "public"."sessions" add column "active_documents" bigint[] not null default '{}'::bigint[];

alter table "public"."sessions" add column "current_document" bigint;

alter table "public"."documents" add constraint "documents_parent_document_id_fkey" FOREIGN KEY (parent_document_id) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."documents" validate constraint "documents_parent_document_id_fkey";

alter table "public"."sessions" add constraint "sessions_current_document_fkey" FOREIGN KEY (current_document) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."sessions" validate constraint "sessions_current_document_fkey";

alter table "public"."users" add column "active_group" bigint;

alter table "public"."users" add constraint "users_active_group_fkey" FOREIGN KEY (active_group) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."users" validate constraint "users_active_group_fkey";


drop policy "Can Insert if Is Group Creator or an Admin" on "public"."group_roles";

drop policy "Can Update if Is Group Admin" on "public"."group_roles";

drop policy "Can delete if Is Their Own Row or Is Group Admin" on "public"."group_roles";

drop policy "Can Select if Is Group Creator or Group Member" on "public"."groups";

drop policy "Enable insert for authenticated users only" on "public"."groups";

drop function if exists "public"."is_group_creator"(_user_uid uuid, _group_id bigint);

create table "public"."group_requests" (
    "id" bigint generated by default as identity not null,
    "group_id" bigint not null,
    "user_uid" uuid not null,
    "group_role" group_role not null
);


alter table "public"."group_requests" enable row level security;

CREATE UNIQUE INDEX group_requests_pkey ON public.group_requests USING btree (id);

alter table "public"."group_requests" add constraint "group_requests_pkey" PRIMARY KEY using index "group_requests_pkey";

alter table "public"."group_requests" add constraint "group_requests_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group_requests" validate constraint "group_requests_group_id_fkey";

alter table "public"."group_requests" add constraint "group_requests_user_uid_fkey" FOREIGN KEY (user_uid) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group_requests" validate constraint "group_requests_user_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_not_last_admin(p_group_id bigint, p_user_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_admin_count integer;
begin
  -- Count number of admins in the group
  select count(*)
  into v_admin_count
  from group_roles
  where group_id = p_group_id
  and role = 'admin'
  and user_uid != p_user_uid;

  -- Return true if there are other admins (count > 0)
  -- Return false if this is the last admin (count = 0)
  return v_admin_count > 0;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.create_group(p_group_name text, p_user_uid uuid)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_group_id bigint;
begin
  -- Input validation
  if p_group_name is null or trim(p_group_name) = '' then
    raise exception 'Group name cannot be null or empty';
  end if;

  -- Create the group and get the new group ID
  insert into groups (group_name)
  values (p_group_name)
  returning id into v_group_id;

  -- Create the admin role for the user
  insert into group_roles (user_uid, role, group_id)
  values (p_user_uid, 'admin', v_group_id);

  return v_group_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_request(p_request_id bigint, p_accept boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_request record;
begin
  -- Get the request details first
  select * into v_request
  from group_requests
  where id = p_request_id;
  
  -- Check if request exists
  if not found then
    raise exception 'Request with ID % not found', p_request_id;
  end if;

  -- If accepting the request
  if p_accept then
    -- Insert the role
    insert into group_roles (user_uid, role, group_id)
    values (
      v_request.user_uid,
      v_request.group_role,
      v_request.group_id
    );
  end if;

  -- Delete the request regardless of acceptance
  delete from group_requests
  where id = p_request_id;

end;
$function$
;

grant delete on table "public"."group_requests" to "anon";

grant insert on table "public"."group_requests" to "anon";

grant references on table "public"."group_requests" to "anon";

grant select on table "public"."group_requests" to "anon";

grant trigger on table "public"."group_requests" to "anon";

grant truncate on table "public"."group_requests" to "anon";

grant update on table "public"."group_requests" to "anon";

grant delete on table "public"."group_requests" to "authenticated";

grant insert on table "public"."group_requests" to "authenticated";

grant references on table "public"."group_requests" to "authenticated";

grant select on table "public"."group_requests" to "authenticated";

grant trigger on table "public"."group_requests" to "authenticated";

grant truncate on table "public"."group_requests" to "authenticated";

grant update on table "public"."group_requests" to "authenticated";

grant delete on table "public"."group_requests" to "service_role";

grant insert on table "public"."group_requests" to "service_role";

grant references on table "public"."group_requests" to "service_role";

grant select on table "public"."group_requests" to "service_role";

grant trigger on table "public"."group_requests" to "service_role";

grant truncate on table "public"."group_requests" to "service_role";

grant update on table "public"."group_requests" to "service_role";

create policy "Can Delete if Is the Recipient"
on "public"."group_requests"
as permissive
for delete
to authenticated
using ((auth.uid() = user_uid));


create policy "Can Send Request if Is Group Admin"
on "public"."group_requests"
as permissive
for insert
to authenticated
with check (is_group_admin(auth.uid(), group_id));


create policy "Can Update if Is Group Admin And Group Has More Than One Admin"
on "public"."group_roles"
as permissive
for update
to authenticated
using ((is_group_admin(auth.uid(), group_id) AND check_not_last_admin(group_id, auth.uid())));


create policy "Enable Delete if Not Last Admin or Own Row"
on "public"."group_roles"
as permissive
for delete
to authenticated
using (((auth.uid() = user_uid) AND check_not_last_admin(group_id, auth.uid())));


create policy "Can Select if Is A Group Member"
on "public"."groups"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), id));

drop function if exists "public"."join_session"(_session_uid uuid, _user_uid uuid);

drop function if exists "public"."update_collaborator_status"(incoming_session_uid uuid, index_to_edit integer, new_status session_user_status);


set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_request(p_request_id bigint, p_accept boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_request record;
begin
  -- Get the request details first
  select * into v_request
  from group_requests
  where id = p_request_id;
  
  -- Check if request exists
  if not found then
    raise exception 'Request with ID % not found', p_request_id;
  end if;

  -- Check if the authenticated user matches the user in the request
  if auth.uid() != v_request.user_uid then
    raise exception 'Not authorized to handle this request';
  end if;

  -- If accepting the request
  if p_accept then
    -- Insert the role
    insert into group_roles (user_uid, role, group_id)
    values (
      v_request.user_uid,
      v_request.group_role,
      v_request.group_id
    );
  end if;

  -- Delete the request regardless of acceptance
  delete from group_requests
  where id = p_request_id;

end;
$function$
;

create or replace function check_users_share_group(
  p_user_uid1 uuid,
  p_user_uid2 uuid
)
returns boolean
security definer
set search_path = public
language plpgsql
as $$
declare
  v_shares_group boolean;
begin
  -- Check if users share any group
  select exists (
    select 1
    from group_roles gr1
    join group_roles gr2 
      on gr1.group_id = gr2.group_id
    where gr1.user_uid = p_user_uid1
    and gr2.user_uid = p_user_uid2
  ) into v_shares_group;

  return v_shares_group;
end;
$$;

-- Grant execute permission to authenticated users
grant execute on function check_users_share_group(uuid, uuid) to authenticated;

create policy "Can Select if Is Their Own Row or Shares a Group With the User"
on "public"."users"
as permissive
for select
to public
using (((auth.uid() = uid) OR check_users_share_group(auth.uid(), uid)));

alter table "public"."users" add column "email" text not null default ''::text;

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

insert into public.users (uid, email)
select 
  id as uid,
  coalesce(email, '') as email
from auth.users
on conflict (uid) do update
set email = coalesce(excluded.email, '');

drop policy "Can Update if Is Group Admin And Group Has More Than One Admin" on "public"."group_roles";

drop policy "Can Delete if Is the Recipient" on "public"."group_requests";

drop policy "Enable Delete if Not Last Admin or Own Row" on "public"."group_roles";

alter table "public"."groups" drop constraint "groups_creator_uid_fkey";

alter table "public"."groups" drop column "creator_uid";

CREATE UNIQUE INDEX unique_user_group_request ON public.group_requests USING btree (user_uid, group_id);

CREATE UNIQUE INDEX unique_user_group_role ON public.group_roles USING btree (user_uid, group_id);

alter table "public"."group_requests" add constraint "unique_user_group_request" UNIQUE using index "unique_user_group_request";

alter table "public"."group_roles" add constraint "unique_user_group_role" UNIQUE using index "unique_user_group_role";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_not_last_admin(p_group_id bigint, p_user_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$declare
  v_admin_count integer;
begin
  -- Count number of admins in the group
  select count(*)
  into v_admin_count
  from group_roles
  where group_id = p_group_id
  and role = 'admin';

  -- Return true if there are other admins (count > 0)
  -- Return false if this is the last admin (count = 0)
  return v_admin_count > 0;
end;$function$
;

create policy "Can Select if Is a Group Admin or Is the Recipient"
on "public"."group_requests"
as permissive
for select
to public
using (((auth.uid() = user_uid) OR is_group_admin(auth.uid(), group_id)));


create policy "Can Update if Is Group Admin And Group At Least One Admin"
on "public"."group_roles"
as permissive
for update
to authenticated
using ((is_group_admin(auth.uid(), group_id) AND check_not_last_admin(group_id, auth.uid())));


-- create policy "Can Delete if Is the Recipient"
-- on "public"."group_requests"
-- as permissive
-- for delete
-- to authenticated
-- using (true);


create policy "Enable Delete if Not Last Admin or Own Row"
on "public"."group_roles"
as permissive
for delete
to authenticated
using ((((auth.uid() = user_uid) AND check_not_last_admin(group_id, auth.uid())) OR (is_group_admin(auth.uid(), group_id) AND (auth.uid() <> user_uid))));

create policy "Enable delete for users based on user_id"
on "public"."group_requests"
as permissive
for delete
to public
using ((auth.uid() = user_uid));

drop policy "Can Update if Is Group Admin And Group At Least One Admin" on "public"."group_roles";

create policy "Can Update if Is Group Admin And Is Not Their Row"
on "public"."group_roles"
as permissive
for update
to authenticated
using ((is_group_admin(auth.uid(), group_id) AND (auth.uid() <> user_uid)));

alter table "public"."group_requests" add column "created_at" timestamp with time zone not null;

alter table "public"."group_requests" add column "sender_full_name" text not null;


alter table "public"."group_requests" add column "group_name" text not null;



create type "public"."gradients" as enum ('glacier', 'lagoon', 'slate', 'cotton_candy', 'twilight_sky', 'amethyst', 'sandstorm', 'desert_dawn', 'ruby');


set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.random_gradient()
 RETURNS gradients
 LANGUAGE sql
AS $function$
    SELECT (
        array['glacier', 'lagoon', 'slate', 'cotton_candy', 'twilight_sky', 'amethyst', 'sandstorm', 'desert_dawn', 'ruby']::public.gradients[]
    )[floor(random() * 9 + 1)];
$function$
;

alter table "public"."users" add column "gradient" gradients default random_gradient();

UPDATE public.users
SET gradient = public.random_gradient()
WHERE gradient IS NULL;

alter table "public"."users" alter column "gradient" set not null;

alter table "public"."groups" add column "gradient" gradients default random_gradient();

UPDATE public.groups
SET gradient = public.random_gradient()
WHERE gradient IS NULL;

alter table "public"."groups" alter column "gradient" set not null;

-- Add new full_name column with empty string default
ALTER TABLE public.users
ADD COLUMN full_name text NOT NULL DEFAULT '';

-- Update the new column with concatenated names
UPDATE public.users
SET full_name = CASE
    -- When both names are present
    WHEN first_name IS NOT NULL AND last_name IS NOT NULL THEN
        first_name || ' ' || last_name
    -- When only first name is present
    WHEN first_name IS NOT NULL THEN
        first_name
    -- When only last name is present
    WHEN last_name IS NOT NULL THEN
        last_name
    -- When both are null
    ELSE ''
END;

-- Drop the original name columns
ALTER TABLE public.users
DROP COLUMN first_name,
DROP COLUMN last_name;

-- Create indexes for full_name and email
CREATE INDEX idx_users_uid ON public.users (uid);
CREATE INDEX idx_users_email ON public.users (email);

-- Create function to check if email exists
CREATE OR REPLACE FUNCTION public.check_email_exists(email_to_check text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    found_uid text;
BEGIN
    SELECT uid::text INTO found_uid
    FROM public.users
    WHERE email = email_to_check
    LIMIT 1;
    
    RETURN COALESCE(found_uid, '');
END;
$function$
;



alter table "public"."group_requests" alter column "created_at" set default now();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.join_session(_session_id bigint, _user_uid uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$DECLARE
    _current_collaborator_uids uuid[];
    _current_collaborator_names text[];
    _current_collaborator_statuses session_user_status[];
    _current_version int4;
    _session_status session_status;
    _user_name text;
BEGIN
    -- Begin transaction
    BEGIN
        -- Retrieve session details from the session_information table
        SELECT 
            version,
            collaborator_uids,
            collaborator_names,
            collaborator_statuses,
            status
        INTO 
            _current_version,
            _current_collaborator_uids,
            _current_collaborator_names,
            _current_collaborator_statuses,
            _session_status
        FROM sessions
        WHERE id IN (
            SELECT id 
            FROM sessions 
            WHERE _session_id = id
        );

        IF _session_id IS NOT NULL THEN
            IF _user_uid = ANY(_current_collaborator_uids) THEN
                RETURN; -- Exit the function if user is already in the collaborator list
            END IF;

            IF _session_status = 'recruiting' THEN
                -- Get the user's name from the users table
                SELECT full_name
                INTO _user_name
                FROM users
                WHERE uid = _user_uid;

                -- Append values to arrays
                _current_collaborator_uids := array_append(_current_collaborator_uids, _user_uid);
                _current_collaborator_names := array_append(_current_collaborator_names, _user_name);
                _current_collaborator_statuses := array_append(_current_collaborator_statuses, 'has_joined'::session_user_status);

                -- Increment version
                _current_version := _current_version + 1;

                -- Update sessions
                UPDATE public.sessions
                SET 
                    collaborator_uids = _current_collaborator_uids,
                    collaborator_names = _current_collaborator_names,
                    collaborator_statuses = _current_collaborator_statuses,
                    version = _current_version
                WHERE id = _session_id
                AND version = _current_version - 1; -- Optimistic locking condition

                -- Check if the update succeeded
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Update on sessions failed due to version mismatch';
                END IF;
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction if anything goes wrong
            RAISE NOTICE 'Transaction failed: %', SQLERRM;
            RAISE; -- Propagate the error
    END;
END;$function$
;


drop function if exists "public"."check_email_exists"(email_to_check text);

alter table "public"."group_requests" add column "recipient_full_name" text not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_by_email(email_to_check text)
 RETURNS users
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    user_record public.users;
BEGIN
    SELECT * INTO user_record
    FROM public.users
    WHERE email = email_to_check 
    LIMIT 1;
    
    RETURN user_record;
END;
$function$
;


alter table "public"."group_requests" add column "recipient_profile_gradient" gradients not null;

alter table "public"."group_requests" add column "sender_profile_gradient" gradients not null;


drop function if exists "public"."create_group"(p_group_name text, p_user_uid uuid);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_group(p_group_name text, p_user_uid uuid, p_profile_gradient gradients)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_group_id bigint;
begin
  -- Input validation
  if p_group_name is null or trim(p_group_name) = '' then
    raise exception 'Group name cannot be null or empty';
  end if;

  -- Create the group and get the new group ID
  insert into groups (group_name,gradient)
  values (p_group_name, p_profile_gradient)
  returning id into v_group_id;

  -- Create the admin role for the user
  insert into group_roles (user_uid, role, group_id)
  values (p_user_uid, 'admin', v_group_id);

  return v_group_id;
end;
$function$
;



drop policy "Enable delete for users based on user_id" on "public"."group_requests";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_by_email(email_to_check text)
 RETURNS users
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$DECLARE
    user_record public.users;
BEGIN
    SELECT * INTO user_record
    FROM public.users
    WHERE email = email_to_check
    LIMIT 1;
    
    RETURN user_record;
END;$function$
;

create policy "Allow Delete if Request Sent by Group Admin or Recipient"
on "public"."group_requests"
as permissive
for delete
to public
using (((auth.uid() = user_uid) OR is_group_admin(auth.uid(), group_id)));

alter
  publication supabase_realtime add table public.group_requests;

alter table "public"."group_requests" replica identity full;


alter
  publication supabase_realtime add table public.groups;

alter table "public"."groups" replica identity full;
