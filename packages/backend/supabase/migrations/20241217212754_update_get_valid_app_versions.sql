drop policy "can read if is a group member" on "public"."finished_sessions";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.43.0'];
END;$function$
;

create policy "broad permissions if is a group member"
on "public"."finished_sessions"
as permissive
for all
to authenticated
using (is_group_member(auth.uid(), group_uid));

