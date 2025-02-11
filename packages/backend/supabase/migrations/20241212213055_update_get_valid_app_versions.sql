alter
  publication supabase_realtime add table public.realtime_active_sessions;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.40.0'];
END;$function$
;


