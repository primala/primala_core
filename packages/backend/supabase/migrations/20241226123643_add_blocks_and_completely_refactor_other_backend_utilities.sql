create type "public"."content_block_type" as enum ('question', 'idea', 'purpose', 'conclusion', 'quotation', 'queue');

create type "public"."session_status" as enum ('dormant', 'recruiting', 'started', 'finished');

create type "public"."session_user_status" as enum ('online', 'offline', 'has_joined', 'ready_to_start', 'ready_to_leave');

drop policy "Enable read access for all users" on "public"."company_presets";

drop policy "Can Insert: If Is not a duplicate" on "public"."company_presets_preferences";

drop policy "Can Read: If Is The Owner" on "public"."company_presets_preferences";

drop policy "Can Update: If is the owner" on "public"."company_presets_preferences";

drop policy "broad permissions if is a group member" on "public"."finished_sessions";

drop policy "INSERT: can insert row if leader of their session" on "public"."realtime_active_sessions";

drop policy "SELECT: They can read their own row" on "public"."realtime_active_sessions";

drop policy "UPDATE: They can update their row if is a valid session" on "public"."realtime_active_sessions";

drop policy "Broad Permissions if Is a Group Member" on "public"."session_queues";

drop policy "SELECT: They can read their row" on "public"."static_active_sessions";

drop policy "UPDATE: Can update valid rows" on "public"."static_active_sessions";

drop policy "can insert a row if they are the leader" on "public"."static_active_sessions";

revoke delete on table "public"."company_presets" from "anon";

revoke insert on table "public"."company_presets" from "anon";

revoke references on table "public"."company_presets" from "anon";

revoke select on table "public"."company_presets" from "anon";

revoke trigger on table "public"."company_presets" from "anon";

revoke truncate on table "public"."company_presets" from "anon";

revoke update on table "public"."company_presets" from "anon";

revoke delete on table "public"."company_presets" from "authenticated";

revoke insert on table "public"."company_presets" from "authenticated";

revoke references on table "public"."company_presets" from "authenticated";

revoke select on table "public"."company_presets" from "authenticated";

revoke trigger on table "public"."company_presets" from "authenticated";

revoke truncate on table "public"."company_presets" from "authenticated";

revoke update on table "public"."company_presets" from "authenticated";

revoke delete on table "public"."company_presets" from "service_role";

revoke insert on table "public"."company_presets" from "service_role";

revoke references on table "public"."company_presets" from "service_role";

revoke select on table "public"."company_presets" from "service_role";

revoke trigger on table "public"."company_presets" from "service_role";

revoke truncate on table "public"."company_presets" from "service_role";

revoke update on table "public"."company_presets" from "service_role";

revoke delete on table "public"."company_presets_preferences" from "anon";

revoke insert on table "public"."company_presets_preferences" from "anon";

revoke references on table "public"."company_presets_preferences" from "anon";

revoke select on table "public"."company_presets_preferences" from "anon";

revoke trigger on table "public"."company_presets_preferences" from "anon";

revoke truncate on table "public"."company_presets_preferences" from "anon";

revoke update on table "public"."company_presets_preferences" from "anon";

revoke delete on table "public"."company_presets_preferences" from "authenticated";

revoke insert on table "public"."company_presets_preferences" from "authenticated";

revoke references on table "public"."company_presets_preferences" from "authenticated";

revoke select on table "public"."company_presets_preferences" from "authenticated";

revoke trigger on table "public"."company_presets_preferences" from "authenticated";

revoke truncate on table "public"."company_presets_preferences" from "authenticated";

revoke update on table "public"."company_presets_preferences" from "authenticated";

revoke delete on table "public"."company_presets_preferences" from "service_role";

revoke insert on table "public"."company_presets_preferences" from "service_role";

revoke references on table "public"."company_presets_preferences" from "service_role";

revoke select on table "public"."company_presets_preferences" from "service_role";

revoke trigger on table "public"."company_presets_preferences" from "service_role";

revoke truncate on table "public"."company_presets_preferences" from "service_role";

revoke update on table "public"."company_presets_preferences" from "service_role";

revoke delete on table "public"."finished_sessions" from "anon";

revoke insert on table "public"."finished_sessions" from "anon";

revoke references on table "public"."finished_sessions" from "anon";

revoke select on table "public"."finished_sessions" from "anon";

revoke trigger on table "public"."finished_sessions" from "anon";

revoke truncate on table "public"."finished_sessions" from "anon";

revoke update on table "public"."finished_sessions" from "anon";

revoke delete on table "public"."finished_sessions" from "authenticated";

revoke insert on table "public"."finished_sessions" from "authenticated";

revoke references on table "public"."finished_sessions" from "authenticated";

revoke select on table "public"."finished_sessions" from "authenticated";

revoke trigger on table "public"."finished_sessions" from "authenticated";

revoke truncate on table "public"."finished_sessions" from "authenticated";

revoke update on table "public"."finished_sessions" from "authenticated";

revoke delete on table "public"."finished_sessions" from "service_role";

revoke insert on table "public"."finished_sessions" from "service_role";

revoke references on table "public"."finished_sessions" from "service_role";

revoke select on table "public"."finished_sessions" from "service_role";

revoke trigger on table "public"."finished_sessions" from "service_role";

revoke truncate on table "public"."finished_sessions" from "service_role";

revoke update on table "public"."finished_sessions" from "service_role";

revoke delete on table "public"."realtime_active_sessions" from "anon";

revoke insert on table "public"."realtime_active_sessions" from "anon";

revoke references on table "public"."realtime_active_sessions" from "anon";

revoke select on table "public"."realtime_active_sessions" from "anon";

revoke trigger on table "public"."realtime_active_sessions" from "anon";

revoke truncate on table "public"."realtime_active_sessions" from "anon";

revoke update on table "public"."realtime_active_sessions" from "anon";

revoke delete on table "public"."realtime_active_sessions" from "authenticated";

revoke insert on table "public"."realtime_active_sessions" from "authenticated";

revoke references on table "public"."realtime_active_sessions" from "authenticated";

revoke select on table "public"."realtime_active_sessions" from "authenticated";

revoke trigger on table "public"."realtime_active_sessions" from "authenticated";

revoke truncate on table "public"."realtime_active_sessions" from "authenticated";

revoke update on table "public"."realtime_active_sessions" from "authenticated";

revoke delete on table "public"."realtime_active_sessions" from "service_role";

revoke insert on table "public"."realtime_active_sessions" from "service_role";

revoke references on table "public"."realtime_active_sessions" from "service_role";

revoke select on table "public"."realtime_active_sessions" from "service_role";

revoke trigger on table "public"."realtime_active_sessions" from "service_role";

revoke truncate on table "public"."realtime_active_sessions" from "service_role";

revoke update on table "public"."realtime_active_sessions" from "service_role";

revoke delete on table "public"."session_queues" from "anon";

revoke insert on table "public"."session_queues" from "anon";

revoke references on table "public"."session_queues" from "anon";

revoke select on table "public"."session_queues" from "anon";

revoke trigger on table "public"."session_queues" from "anon";

revoke truncate on table "public"."session_queues" from "anon";

revoke update on table "public"."session_queues" from "anon";

revoke delete on table "public"."session_queues" from "authenticated";

revoke insert on table "public"."session_queues" from "authenticated";

revoke references on table "public"."session_queues" from "authenticated";

revoke select on table "public"."session_queues" from "authenticated";

revoke trigger on table "public"."session_queues" from "authenticated";

revoke truncate on table "public"."session_queues" from "authenticated";

revoke update on table "public"."session_queues" from "authenticated";

revoke delete on table "public"."session_queues" from "service_role";

revoke insert on table "public"."session_queues" from "service_role";

revoke references on table "public"."session_queues" from "service_role";

revoke select on table "public"."session_queues" from "service_role";

revoke trigger on table "public"."session_queues" from "service_role";

revoke truncate on table "public"."session_queues" from "service_role";

revoke update on table "public"."session_queues" from "service_role";

revoke delete on table "public"."static_active_sessions" from "anon";

revoke insert on table "public"."static_active_sessions" from "anon";

revoke references on table "public"."static_active_sessions" from "anon";

revoke select on table "public"."static_active_sessions" from "anon";

revoke trigger on table "public"."static_active_sessions" from "anon";

revoke truncate on table "public"."static_active_sessions" from "anon";

revoke update on table "public"."static_active_sessions" from "anon";

revoke delete on table "public"."static_active_sessions" from "authenticated";

revoke insert on table "public"."static_active_sessions" from "authenticated";

revoke references on table "public"."static_active_sessions" from "authenticated";

revoke select on table "public"."static_active_sessions" from "authenticated";

revoke trigger on table "public"."static_active_sessions" from "authenticated";

revoke truncate on table "public"."static_active_sessions" from "authenticated";

revoke update on table "public"."static_active_sessions" from "authenticated";

revoke delete on table "public"."static_active_sessions" from "service_role";

revoke insert on table "public"."static_active_sessions" from "service_role";

revoke references on table "public"."static_active_sessions" from "service_role";

revoke select on table "public"."static_active_sessions" from "service_role";

revoke trigger on table "public"."static_active_sessions" from "service_role";

revoke truncate on table "public"."static_active_sessions" from "service_role";

revoke update on table "public"."static_active_sessions" from "service_role";

alter table "public"."company_presets" drop constraint "company_presets_name_key";

alter table "public"."company_presets_preferences" drop constraint "check_valid_tags";

alter table "public"."company_presets_preferences" drop constraint "company_presets_preferences_company_preset_fkey";

alter table "public"."company_presets_preferences" drop constraint "company_presets_preferences_owner_uid_check";

alter table "public"."company_presets_preferences" drop constraint "company_presets_preferences_owner_uid_fkey";

alter table "public"."company_presets_preferences" drop constraint "user_generated_presets_uid_key";

alter table "public"."finished_sessions" drop constraint "finished_sessions_group_uid_fkey";

alter table "public"."realtime_active_sessions" drop constraint "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."realtime_active_sessions" drop constraint "rt_active_nokhte_sessions_secondary_speaker_spotlight_fkey";

alter table "public"."realtime_active_sessions" drop constraint "rt_active_nokhte_sessions_session_uid_fkey";

alter table "public"."realtime_active_sessions" drop constraint "rt_active_nokhte_sessions_speaker_spotlight_fkey";

alter table "public"."session_queues" drop constraint "session_queues_group_uid_fkey";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_duplicate_collaborator_uids_key";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_duplicate_session_uid_key";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_leader_uid_fkey";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_leader_uid_key";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_preset_uid_fkey";

alter table "public"."static_active_sessions" drop constraint "static_active_sessions_group_uid_fkey";

alter table "public"."static_active_sessions" drop constraint "static_active_sessions_queue_uid_fkey";

alter table "public"."user_information" drop constraint "user_information_new_preferred_preset_fkey";

drop function if exists "public"."check_valid_tags"(preference_tags session_presets_tags[], company_preset_uid uuid);

drop function if exists "public"."is_not_updating_has_premium_access"(_uid uuid, _has_premium_access boolean[]);

alter table "public"."company_presets" drop constraint "company_presets_pkey";

alter table "public"."company_presets_preferences" drop constraint "user_generated_presets_pkey";

alter table "public"."finished_sessions" drop constraint "finished_nokhte_sessions_pkey";

alter table "public"."realtime_active_sessions" drop constraint "rt_active_nokhte_sessions_pkey";

alter table "public"."session_queues" drop constraint "session_queues_pkey";

alter table "public"."static_active_sessions" drop constraint "st_active_nokhte_sessions_pkey";

drop index if exists "public"."company_presets_name_key";

drop index if exists "public"."company_presets_pkey";

drop index if exists "public"."finished_nokhte_sessions_pkey";

drop index if exists "public"."session_queues_pkey";

drop index if exists "public"."st_active_nokhte_sessions_duplicate_collaborator_uids_key";

drop index if exists "public"."st_active_nokhte_sessions_duplicate_session_uid_key";

drop index if exists "public"."st_active_nokhte_sessions_leader_uid_key";

drop index if exists "public"."st_active_nokhte_sessions_pkey";

drop index if exists "public"."user_generated_presets_pkey";

drop index if exists "public"."user_generated_presets_uid_key";

drop index if exists "public"."active_irl_nokhte_sessions_session_uid_key";

drop index if exists "public"."rt_active_nokhte_sessions_pkey";

drop table "public"."company_presets";

drop table "public"."company_presets_preferences";

drop table "public"."finished_sessions";

drop table "public"."realtime_active_sessions";

drop table "public"."session_queues";

drop table "public"."static_active_sessions";

create table "public"."session_content" (
    "session_uid" uuid not null,
    "last_edited_at" timestamp with time zone not null default now(),
    "type" content_block_type not null,
    "content" text not null,
    "parent_uid" uuid,
    "uid" uuid not null default gen_random_uuid()
);


alter table "public"."session_content" enable row level security;

create table "public"."session_information" (
    "uid" uuid not null default gen_random_uuid(),
    "speaker_spotlight" uuid,
    "version" integer not null default 0,
    "secondary_speaker_spotlight" uuid,
    "speaking_timer_start" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "group_uid" uuid not null,
    "status" session_status default 'recruiting'::session_status,
    "title" text default ''::text,
    "user_metadata" jsonb
);


alter table "public"."session_information" enable row level security;

alter table "public"."user_information" drop column "preferred_preset";

drop type "public"."session_phone_types";

CREATE UNIQUE INDEX session_content_pkey ON public.session_content USING btree (session_uid);

CREATE UNIQUE INDEX session_content_uid_key ON public.session_content USING btree (uid);

CREATE UNIQUE INDEX active_irl_nokhte_sessions_session_uid_key ON public.session_information USING btree (uid);

CREATE UNIQUE INDEX rt_active_nokhte_sessions_pkey ON public.session_information USING btree (uid);

alter table "public"."session_content" add constraint "session_content_pkey" PRIMARY KEY using index "session_content_pkey";

alter table "public"."session_information" add constraint "rt_active_nokhte_sessions_pkey" PRIMARY KEY using index "rt_active_nokhte_sessions_pkey";

alter table "public"."session_content" add constraint "session_content_parent_uid_fkey" FOREIGN KEY (parent_uid) REFERENCES session_content(uid) not valid;

alter table "public"."session_content" validate constraint "session_content_parent_uid_fkey";

alter table "public"."session_content" add constraint "session_content_session_uid_fkey" FOREIGN KEY (session_uid) REFERENCES session_information(uid) not valid;

alter table "public"."session_content" validate constraint "session_content_session_uid_fkey";

alter table "public"."session_content" add constraint "session_content_uid_key" UNIQUE using index "session_content_uid_key";

alter table "public"."session_information" add constraint "active_irl_nokhte_sessions_session_uid_key" UNIQUE using index "active_irl_nokhte_sessions_session_uid_key";

alter table "public"."session_information" add constraint "session_information_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) not valid;

alter table "public"."session_information" validate constraint "session_information_group_uid_fkey";

alter table "public"."session_information" add constraint "session_information_secondary_speaker_spotlight_fkey" FOREIGN KEY (secondary_speaker_spotlight) REFERENCES user_information(uid) not valid;

alter table "public"."session_information" validate constraint "session_information_secondary_speaker_spotlight_fkey";

alter table "public"."session_information" add constraint "session_information_speaker_spotlight_fkey" FOREIGN KEY (speaker_spotlight) REFERENCES user_information(uid) not valid;

alter table "public"."session_information" validate constraint "session_information_speaker_spotlight_fkey";

grant delete on table "public"."session_content" to "anon";

grant insert on table "public"."session_content" to "anon";

grant references on table "public"."session_content" to "anon";

grant select on table "public"."session_content" to "anon";

grant trigger on table "public"."session_content" to "anon";

grant truncate on table "public"."session_content" to "anon";

grant update on table "public"."session_content" to "anon";

grant delete on table "public"."session_content" to "authenticated";

grant insert on table "public"."session_content" to "authenticated";

grant references on table "public"."session_content" to "authenticated";

grant select on table "public"."session_content" to "authenticated";

grant trigger on table "public"."session_content" to "authenticated";

grant truncate on table "public"."session_content" to "authenticated";

grant update on table "public"."session_content" to "authenticated";

grant delete on table "public"."session_content" to "service_role";

grant insert on table "public"."session_content" to "service_role";

grant references on table "public"."session_content" to "service_role";

grant select on table "public"."session_content" to "service_role";

grant trigger on table "public"."session_content" to "service_role";

grant truncate on table "public"."session_content" to "service_role";

grant update on table "public"."session_content" to "service_role";

grant delete on table "public"."session_information" to "anon";

grant insert on table "public"."session_information" to "anon";

grant references on table "public"."session_information" to "anon";

grant select on table "public"."session_information" to "anon";

grant trigger on table "public"."session_information" to "anon";

grant truncate on table "public"."session_information" to "anon";

grant update on table "public"."session_information" to "anon";

grant delete on table "public"."session_information" to "authenticated";

grant insert on table "public"."session_information" to "authenticated";

grant references on table "public"."session_information" to "authenticated";

grant select on table "public"."session_information" to "authenticated";

grant trigger on table "public"."session_information" to "authenticated";

grant truncate on table "public"."session_information" to "authenticated";

grant update on table "public"."session_information" to "authenticated";

grant delete on table "public"."session_information" to "service_role";

grant insert on table "public"."session_information" to "service_role";

grant references on table "public"."session_information" to "service_role";

grant select on table "public"."session_information" to "service_role";

grant trigger on table "public"."session_information" to "service_role";

grant truncate on table "public"."session_information" to "service_role";

grant update on table "public"."session_information" to "service_role";

alter
  publication supabase_realtime add table public.session_information;

alter
  publication supabase_realtime add table public.session_content;

CREATE OR REPLACE FUNCTION public.user_metadata_matches_schema(user_data jsonb)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
    RETURN jsonb_matches_schema(schema :='{
        "type": "object",
        "properties": {
            "users": {
                "type": "object",
                "additionalProperties": {
                    "type": "object",
                    "required": ["state", "name"],
                    "properties": {
                        "state": {
                            "type": "string",
                            "enum": ["online", "offline", "has_joined", "has_not_joined", "ready_to_start", "ready_to_leave"]
                        },
                        "name": {
                            "type": "string",
                            "minLength": 1
                        }
                    },
                    "additionalProperties": false
                }
            }
        },
        "required": ["users"],
        "additionalProperties": false
    }',instance := user_data);
END;$function$
;

drop function if exists "public"."join_session"(_leader_uid uuid, _user_uid uuid);

drop function if exists "public"."update_nokhte_session_phase"(incoming_session_uid uuid, index_to_edit integer, new_value real);

alter table "public"."session_information" add constraint "session_information_user_metadata_check" CHECK (user_metadata_matches_schema(user_metadata)) not valid;

alter table "public"."session_information" validate constraint "session_information_user_metadata_check";

set check_function_bodies = off;

-- set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.join_session(p_session_uid uuid, p_user_name text, p_user_uid uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_current_metadata JSONB;
BEGIN
    -- Get current metadata
    SELECT user_metadata INTO v_current_metadata
    FROM session_information
    WHERE uid = p_session_uid;
    
    -- Initialize metadata if null
    IF v_current_metadata IS NULL THEN
        v_current_metadata := '{"users": {}}'::JSONB;
    END IF;
    
    -- Add new user to metadata
    v_current_metadata := jsonb_set(
        v_current_metadata,
        '{users, ' || p_user_uid || '}',
        jsonb_build_object(
            'name', p_user_name,
            'state', 'has_joined'
        )
    );
    
    -- Update the session
    UPDATE session_information
    SET 
        user_metadata = v_current_metadata,
        version = version + 1
    WHERE uid = p_session_uid;
    
    RETURN v_current_metadata;
    
EXCEPTION WHEN others THEN
    RAISE EXCEPTION 'Failed to join session: %', SQLERRM;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_session_user_metadata(p_session_uid uuid, p_user_uid uuid, p_new_state session_user_status)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_current_metadata JSONB;
    v_user_exists BOOLEAN;
BEGIN
    -- Get current metadata
    SELECT 
        user_metadata,
        user_metadata->'users' ? p_user_uid::TEXT INTO v_current_metadata, v_user_exists
    FROM session_information
    WHERE uid = p_session_uid;
    
    -- Check if user exists in the session
    IF NOT v_user_exists THEN
        RAISE EXCEPTION 'User % not found in session %', p_user_uid, p_session_uid;
    END IF;
    
    -- Update user's state
    v_current_metadata := jsonb_set(
        v_current_metadata,
        '{users, ' || p_user_uid || ', state}',
        to_jsonb(p_new_state)
    );
    
    -- Update the session
    UPDATE session_information
    SET 
        user_metadata = v_current_metadata,
        version = version + 1
    WHERE uid = p_session_uid;
    
    RETURN v_current_metadata;
    
EXCEPTION WHEN others THEN
    RAISE EXCEPTION 'Failed to update user state: %', SQLERRM;
END;
$function$
;


alter table "public"."session_information" drop constraint "session_information_user_metadata_check";

drop function if exists "public"."join_session"(p_session_uid uuid, p_user_name text, p_user_uid uuid);

drop function if exists "public"."update_session_user_metadata"(p_session_uid uuid, p_user_uid uuid, p_new_state session_user_status);

drop function if exists "public"."user_metadata_matches_schema"(user_data jsonb);

alter table "public"."session_information" drop column "user_metadata";

alter table "public"."session_information" add column "collaborator_names" text[] not null;

alter table "public"."session_information" add column "collaborator_statuses" session_user_status not null;

alter table "public"."session_information" add column "collaborator_uids" uuid[] not null;

CREATE UNIQUE INDEX session_information_collaborator_statuses_key ON public.session_information USING btree (collaborator_statuses);

alter table "public"."session_information" add constraint "session_information_collaborator_statuses_key" UNIQUE using index "session_information_collaborator_statuses_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.join_session(_session_uid uuid, _user_uid uuid)
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
        FROM session_information
        WHERE uid IN (
            SELECT uid 
            FROM session_information 
            WHERE _session_uid = uid
        );

        IF _session_uid IS NOT NULL THEN
            IF _user_uid = ANY(_current_collaborator_uids) THEN
                RETURN; -- Exit the function if user is already in the collaborator list
            END IF;

            IF _session_status = 'recruiting' THEN
                -- Get the user's name from the user_information table
                SELECT first_name || ' ' || last_name
                INTO _user_name
                FROM user_information
                WHERE uid = _user_uid;

                -- Append values to arrays
                _current_collaborator_uids := array_append(_current_collaborator_uids, _user_uid);
                _current_collaborator_names := array_append(_current_collaborator_names, _user_name);
                _current_collaborator_statuses := array_append(_current_collaborator_statuses, 'has_joined'::session_user_status);

                -- Increment version
                _current_version := _current_version + 1;

                -- Update session_information
                UPDATE public.session_information
                SET 
                    collaborator_uids = _current_collaborator_uids,
                    collaborator_names = _current_collaborator_names,
                    collaborator_statuses = _current_collaborator_statuses,
                    version = _current_version
                WHERE uid = _session_uid
                AND version = _current_version - 1; -- Optimistic locking condition

                -- Check if the update succeeded
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Update on session_information failed due to version mismatch';
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

CREATE OR REPLACE FUNCTION public.update_collaborator_status(incoming_session_uid uuid, index_to_edit integer, new_status session_user_status)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
    update public.session_information SET current_phases[index_to_edit+1] = new_status WHERE session_uid = incoming_session_uid;
END;$function$
;

create policy "Broad Permissions if Is a Group Member"
on "public"."session_information"
as permissive
for all
to authenticated
using (is_group_member(auth.uid(), group_uid));

drop type "public"."session_presets_tags";

drop policy "Broad Permissions if Is a Group Member" on "public"."session_information";

alter table "public"."session_information" drop constraint "session_information_collaborator_statuses_key";

-- drop index if exists "public"."session_information_collaborator_statuses_key";

-- alter table "public"."session_information" alter column "collaborator_statuses" set data type session_user_status[] using "collaborator_statuses"::session_user_status[];

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_collaborator_status(incoming_session_uid uuid, index_to_edit integer, new_status session_user_status)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
    update public.session_information SET collaborator_statuses[index_to_edit+1] = new_status WHERE uid = incoming_session_uid;
END;$function$
;

create policy "Anyone Can Insert a Row"
on "public"."session_information"
as permissive
for insert
to authenticated
with check (is_group_member(auth.uid(), group_uid));


create policy "Can Delete if Is a Group Member"
on "public"."session_information"
as permissive
for delete
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Read if Is a Group Member"
on "public"."session_information"
as permissive
for select
to authenticated
using (is_group_member(auth.uid(), group_uid));


create policy "Can Update if Is a Group Member"
on "public"."session_information"
as permissive
for update
to authenticated
using (is_group_member(auth.uid(), group_uid));


alter table "public"."session_content" drop constraint "session_content_pkey";

drop index if exists "public"."session_content_pkey";

alter table "public"."session_information" drop column "collaborator_statuses";

CREATE UNIQUE INDEX session_content_pkey ON public.session_content USING btree (uid);

alter table "public"."session_content" add constraint "session_content_pkey" PRIMARY KEY using index "session_content_pkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_membership_from_session_uid(session_uid_param uuid, user_uid_param uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    group_id uuid;
BEGIN
    -- Get the group_uid for the session
    SELECT group_uid INTO group_id
    FROM session_information
    WHERE uid = session_uid_param;

    -- If no session found, return false
    IF group_id IS NULL THEN
        RETURN false;
    END IF;

    -- Check if the user_uid exists in the group_members array
    RETURN EXISTS (
        SELECT 1
        FROM group_information
        WHERE uid = group_id
        AND user_uid_param = ANY(group_members)
    );
END;
$function$
;


alter table "public"."session_information" add column "collaborator_statuses" session_user_status[] not null;

create policy "Can Delete if Is a Group Member"
on "public"."session_content"
as permissive
for delete
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));


create policy "Can Update if Is a Group Member"
on "public"."session_content"
as permissive
for update
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));


create policy "Enable insert for authenticated users only"
on "public"."session_content"
as permissive
for insert
to authenticated
with check (true);


create policy "can select if is a member"
on "public"."session_content"
as permissive
for select
to authenticated
using (check_membership_from_session_uid(session_uid, auth.uid()));
