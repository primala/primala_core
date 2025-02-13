
alter table "public"."users" drop constraint "user_information_uid_fkey";

alter table "public"."users" add constraint "users_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_uid_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_valid_app_versions()
 RETURNS text[]
 LANGUAGE plpgsql
AS $function$BEGIN 
    RETURN ARRAY['2.63.0'];
END;$function$
;
