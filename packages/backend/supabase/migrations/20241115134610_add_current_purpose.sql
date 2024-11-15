alter table "public"."rt_active_nokhte_sessions" add column "current_purpose" text not null default ''::text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.27.0'];
END;$function$
;