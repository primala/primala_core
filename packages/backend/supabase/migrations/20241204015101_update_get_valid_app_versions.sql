alter table "public"."rt_active_nokhte_sessions" alter column "current_phases" set default '{1}'::real[];

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.32.0'];
END;$function$
;