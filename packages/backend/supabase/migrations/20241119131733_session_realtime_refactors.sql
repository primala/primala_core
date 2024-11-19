alter table "public"."rt_active_nokhte_sessions" drop column "current_purpose";

alter table "public"."rt_active_nokhte_sessions" add column "content" text[] not null default '{}'::text[];

alter table "public"."st_active_nokhte_sessions" drop column "content";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.29.0'];
END;$function$
;
