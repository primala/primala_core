
alter table "public"."users" alter column "full_name" set default '''Nokhte User''::text'::text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.65.0'];
END;$function$
;
