alter table "public"."finished_sessions" drop constraint "finished_sessions_group_uid_fkey";

alter table "public"."session_queues" drop constraint "session_queues_group_uid_fkey";

alter table "public"."static_active_sessions" add column "queue_uid" uuid;

alter table "public"."static_active_sessions" add constraint "static_active_sessions_queue_uid_fkey" FOREIGN KEY (queue_uid) REFERENCES session_queues(uid) not valid;

alter table "public"."static_active_sessions" validate constraint "static_active_sessions_queue_uid_fkey";

alter table "public"."finished_sessions" add constraint "finished_sessions_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."finished_sessions" validate constraint "finished_sessions_group_uid_fkey";

alter table "public"."session_queues" add constraint "session_queues_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."session_queues" validate constraint "session_queues_group_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.38.0'];
END;$function$
;

