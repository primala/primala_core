alter table "public"."rt_active_nokhte_sessions" add column "version" integer not null default 0;

alter table "public"."st_active_nokhte_sessions" add column "version" integer not null default 0;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.join_session(_leader_uid uuid, _user_uid uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    _current_is_online bool[];
    _current_phases float4[];
    _current_collaborator_uids uuid[];
    _current_static_version int4;
    _current_realtime_version int4;
    _session_uid uuid;
    _session_has_started bool;
BEGIN
    -- Begin transaction
    BEGIN
        -- Retrieve session details from the static table
        SELECT session_uid, version, collaborator_uids 
        INTO _session_uid, _current_static_version, _current_collaborator_uids
        FROM st_active_nokhte_sessions
        WHERE leader_uid = _leader_uid;
    
        IF _session_uid IS NOT NULL THEN
            -- Retrieve session details from the realtime table
            SELECT current_phases, is_online, has_begun, version
            INTO _current_phases, _current_is_online, _session_has_started, _current_realtime_version
            FROM rt_active_nokhte_sessions 
            WHERE session_uid = _session_uid;

            IF NOT _session_has_started THEN
                -- Append values to arrays
                _current_is_online := array_append(_current_is_online, true);
                _current_phases := array_append(_current_phases, 0);
                _current_collaborator_uids := array_append(_current_collaborator_uids, _user_uid);

                -- Increment versions
                _current_static_version := _current_static_version + 1;
                _current_realtime_version := _current_realtime_version + 1;

                -- First update in st_active_nokhte_sessions
                UPDATE public.st_active_nokhte_sessions
                SET collaborator_uids = _current_collaborator_uids,
                    version = _current_static_version
                WHERE leader_uid = _leader_uid 
                AND version = _current_static_version - 1; -- Optimistic locking condition

                -- Check if the first update succeeded
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Update on st_active_nokhte_sessions failed due to version mismatch';
                END IF;

                -- Second update in rt_active_nokhte_sessions
                UPDATE public.rt_active_nokhte_sessions 
                SET current_phases = _current_phases, 
                    is_online = _current_is_online,
                    version = _current_realtime_version
                WHERE session_uid = _session_uid 
                AND version = _current_realtime_version - 1; -- Optimistic locking condition

                -- Check if the second update succeeded
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Update on rt_active_nokhte_sessions failed due to version mismatch';
                END IF;
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction if anything goes wrong
            RAISE NOTICE 'Transaction failed: %', SQLERRM;
            -- Optionally: implement retry logic here if necessary
            RAISE; -- Propagate the error if needed
    END;
END;
$function$
;
