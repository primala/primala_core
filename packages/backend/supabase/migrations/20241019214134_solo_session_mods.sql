ALTER TABLE public.user_information
ADD COLUMN new_preferred_preset uuid;

UPDATE public.user_information ui
SET new_preferred_preset = cp.uid
FROM public.unified_presets up
JOIN public.company_presets cp ON up.company_preset_id = cp.uid
WHERE ui.preferred_preset = up.uid AND up.is_company_preset = true;

UPDATE public.user_information ui
SET new_preferred_preset = NULL
FROM public.unified_presets up
WHERE ui.preferred_preset = up.uid AND up.is_company_preset = false;

ALTER TABLE public.user_information
DROP CONSTRAINT user_information_preferred_preset_fkey;

ALTER TABLE public.user_information
DROP COLUMN preferred_preset;

ALTER TABLE public.user_information
RENAME COLUMN new_preferred_preset TO preferred_preset;

ALTER TABLE public.user_information
ADD CONSTRAINT user_information_preferred_preset_fkey
FOREIGN KEY (preferred_preset)
REFERENCES public.company_presets (uid)
ON UPDATE CASCADE
ON DELETE SET NULL;



drop policy "Enable read access for all users" on "public"."unified_presets";

revoke delete on table "public"."unified_presets" from "anon";

revoke insert on table "public"."unified_presets" from "anon";

revoke references on table "public"."unified_presets" from "anon";

revoke select on table "public"."unified_presets" from "anon";

revoke trigger on table "public"."unified_presets" from "anon";

revoke truncate on table "public"."unified_presets" from "anon";

revoke update on table "public"."unified_presets" from "anon";

revoke delete on table "public"."unified_presets" from "authenticated";

revoke insert on table "public"."unified_presets" from "authenticated";

revoke references on table "public"."unified_presets" from "authenticated";

revoke select on table "public"."unified_presets" from "authenticated";

revoke trigger on table "public"."unified_presets" from "authenticated";

revoke truncate on table "public"."unified_presets" from "authenticated";

revoke update on table "public"."unified_presets" from "authenticated";

revoke delete on table "public"."unified_presets" from "service_role";

revoke insert on table "public"."unified_presets" from "service_role";

revoke references on table "public"."unified_presets" from "service_role";

revoke select on table "public"."unified_presets" from "service_role";

revoke trigger on table "public"."unified_presets" from "service_role";

revoke truncate on table "public"."unified_presets" from "service_role";

revoke update on table "public"."unified_presets" from "service_role";

alter table "public"."finished_nokhte_sessions" drop constraint "finished_nokhte_sessions_preset_uid_fkey";

alter table "public"."unified_presets" drop constraint "exclusive_or_constraint";

alter table "public"."unified_presets" drop constraint "unified_presets_company_preset_id_fkey";

alter table "public"."unified_presets" drop constraint "unified_presets_user_generated_preset_id_fkey";

alter table "public"."user_information" drop constraint "user_information_preferred_preset_fkey";

alter table "public"."st_active_nokhte_sessions" drop constraint "st_active_nokhte_sessions_preset_uid_fkey";

alter table "public"."unified_presets" drop constraint "unified_presets_pkey";

drop index if exists "public"."finished_nokhte_sessions_preset_uid_idx";

drop index if exists "public"."unified_presets_pkey";

drop table "public"."unified_presets";

alter table "public"."finished_nokhte_sessions" drop column "preset_uid";

alter table "public"."user_generated_presets" drop column "created_at";

alter table "public"."user_generated_presets" add column "company_preset" uuid not null;

alter table "public"."user_generated_presets" add column "options" jsonb not null default '{}'::jsonb;

alter table "public"."user_generated_presets" add column "owner_uid" uuid not null default auth.uid();

alter table "public"."user_information" add constraint "user_information_new_preferred_preset_fkey" FOREIGN KEY (preferred_preset) REFERENCES company_presets(uid) not valid;

alter table "public"."user_information" validate constraint "user_information_new_preferred_preset_fkey";

alter table "public"."st_active_nokhte_sessions" add constraint "st_active_nokhte_sessions_preset_uid_fkey" FOREIGN KEY (preset_uid) REFERENCES company_presets(uid) not valid;

alter table "public"."st_active_nokhte_sessions" validate constraint "st_active_nokhte_sessions_preset_uid_fkey";

revoke delete on table "public"."user_generated_presets" from "anon";

revoke insert on table "public"."user_generated_presets" from "anon";

revoke references on table "public"."user_generated_presets" from "anon";

revoke select on table "public"."user_generated_presets" from "anon";

revoke trigger on table "public"."user_generated_presets" from "anon";

revoke truncate on table "public"."user_generated_presets" from "anon";

revoke update on table "public"."user_generated_presets" from "anon";

revoke delete on table "public"."user_generated_presets" from "authenticated";

revoke insert on table "public"."user_generated_presets" from "authenticated";

revoke references on table "public"."user_generated_presets" from "authenticated";

revoke select on table "public"."user_generated_presets" from "authenticated";

revoke trigger on table "public"."user_generated_presets" from "authenticated";

revoke truncate on table "public"."user_generated_presets" from "authenticated";

revoke update on table "public"."user_generated_presets" from "authenticated";

revoke delete on table "public"."user_generated_presets" from "service_role";

revoke insert on table "public"."user_generated_presets" from "service_role";

revoke references on table "public"."user_generated_presets" from "service_role";

revoke select on table "public"."user_generated_presets" from "service_role";

revoke trigger on table "public"."user_generated_presets" from "service_role";

revoke truncate on table "public"."user_generated_presets" from "service_role";

revoke update on table "public"."user_generated_presets" from "service_role";

alter table "public"."user_generated_presets" drop constraint "user_generated_presets_uid_key";

alter table "public"."user_information" drop constraint "user_information_flags_check";

alter table "public"."user_generated_presets" drop constraint "user_generated_presets_pkey";

drop index if exists "public"."user_generated_presets_pkey";

drop index if exists "public"."user_generated_presets_uid_key";

drop table "public"."user_generated_presets";

create table "public"."company_presets_preferences" (
    "uid" uuid not null,
    "owner_uid" uuid not null,
    "company_preset" uuid not null,
    "options" jsonb not null default '{}'::jsonb
);


alter table "public"."company_presets_preferences" enable row level security;

alter table "public"."user_information" drop column "flags";

CREATE UNIQUE INDEX user_generated_presets_pkey ON public.company_presets_preferences USING btree (uid);

CREATE UNIQUE INDEX user_generated_presets_uid_key ON public.company_presets_preferences USING btree (uid);

alter table "public"."company_presets_preferences" add constraint "user_generated_presets_pkey" PRIMARY KEY using index "user_generated_presets_pkey";

alter table "public"."company_presets_preferences" add constraint "company_presets_preferences_company_preset_fkey" FOREIGN KEY (company_preset) REFERENCES company_presets(uid) not valid;

alter table "public"."company_presets_preferences" validate constraint "company_presets_preferences_company_preset_fkey";

alter table "public"."company_presets_preferences" add constraint "company_presets_preferences_owner_uid_fkey" FOREIGN KEY (owner_uid) REFERENCES auth.users(id) not valid;

alter table "public"."company_presets_preferences" validate constraint "company_presets_preferences_owner_uid_fkey";

alter table "public"."company_presets_preferences" add constraint "user_generated_presets_uid_key" UNIQUE using index "user_generated_presets_uid_key";

grant delete on table "public"."company_presets_preferences" to "anon";

grant insert on table "public"."company_presets_preferences" to "anon";

grant references on table "public"."company_presets_preferences" to "anon";

grant select on table "public"."company_presets_preferences" to "anon";

grant trigger on table "public"."company_presets_preferences" to "anon";

grant truncate on table "public"."company_presets_preferences" to "anon";

grant update on table "public"."company_presets_preferences" to "anon";

grant delete on table "public"."company_presets_preferences" to "authenticated";

grant insert on table "public"."company_presets_preferences" to "authenticated";

grant references on table "public"."company_presets_preferences" to "authenticated";

grant select on table "public"."company_presets_preferences" to "authenticated";

grant trigger on table "public"."company_presets_preferences" to "authenticated";

grant truncate on table "public"."company_presets_preferences" to "authenticated";

grant update on table "public"."company_presets_preferences" to "authenticated";

grant delete on table "public"."company_presets_preferences" to "service_role";

grant insert on table "public"."company_presets_preferences" to "service_role";

grant references on table "public"."company_presets_preferences" to "service_role";

grant select on table "public"."company_presets_preferences" to "service_role";

grant trigger on table "public"."company_presets_preferences" to "service_role";

grant truncate on table "public"."company_presets_preferences" to "service_role";

grant update on table "public"."company_presets_preferences" to "service_role";

alter table "public"."company_presets_preferences" alter column "options" set default '{"enableNotes": false, "enableHoldToTalk": false}'::jsonb;

alter table "public"."company_presets_preferences" add constraint "company_presets_preferences_options_check" CHECK (jsonb_matches_schema('{"enableNotes": "bool", "enableHoldToTalk":"bool"}'::json, options)) not valid;

alter table "public"."company_presets_preferences" validate constraint "company_presets_preferences_options_check";



BEGIN;

DELETE FROM public.company_presets
WHERE name ILIKE '%cratic%';

COMMIT;



BEGIN;

ALTER TABLE public.company_presets
ADD COLUMN phone_types session_phone_types;

UPDATE public.company_presets
SET phone_types = (even_configuration)[1];

ALTER TABLE public.company_presets
DROP COLUMN even_configuration,
DROP COLUMN odd_configuration;

COMMIT;

BEGIN;

ALTER TABLE public.company_presets
RENAME COLUMN phone_types TO phone_type;

UPDATE public.company_presets
SET phone_type = phone_type;

COMMIT;

alter table "public"."company_presets_preferences" drop constraint "company_presets_preferences_options_check";

alter type "public"."session_phone_types" rename to "session_phone_types__old_version_to_be_dropped";

create type "public"."session_phone_types" as enum ('solo_hybrid', 'group_hybrid', 'polymorphic_solo');

alter type "public"."session_presets_tags" rename to "session_presets_tags__old_version_to_be_dropped";

create type "public"."session_presets_tags" as enum ('strict_seating', 'flexible_seating', 'no_seating', 'hold_to_speak', 'tap_to_speak', 'mono_focal_notes', 'multi_focal_notes', 'deactivated_notes');

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_valid_tags(preference_tags session_presets_tags[], company_preset_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    company_preset_tags session_presets_tags[];
BEGIN
    SELECT tags INTO company_preset_tags
    FROM public.company_presets
    WHERE uid = company_preset_uid;

    RETURN preference_tags <@ company_preset_tags;
END;
$function$
;

create policy "Can Insert: If Is not a duplicate"
on "public"."company_presets_preferences"
as permissive
for insert
to authenticated
with check (((NOT (EXISTS ( SELECT 1
   FROM company_presets_preferences company_presets_preferences_1
  WHERE ((company_presets_preferences_1.owner_uid = auth.uid()) AND (company_presets_preferences_1.company_preset = company_presets_preferences_1.company_preset))))) AND (auth.uid() = owner_uid)));


create policy "Can Read: If Is The Owner"
on "public"."company_presets_preferences"
as permissive
for select
to authenticated
using ((owner_uid = auth.uid()));


create policy "Can Update: If is the owner"
on "public"."company_presets_preferences"
as permissive
for update
to authenticated
using ((auth.uid() = owner_uid));

alter table "public"."company_presets" alter column "phone_type" set not null;

alter table "public"."company_presets" alter column "phone_type" set data type session_phone_types using "phone_type"::text::session_phone_types;

alter table "public"."company_presets" alter column "tags" set data type text[];

alter table "public"."company_presets_preferences" drop column "options";

alter table "public"."company_presets_preferences" add column "tags" session_presets_tags[] not null;

drop type "public"."session_phone_types__old_version_to_be_dropped";

drop type "public"."session_presets_tags__old_version_to_be_dropped";

alter table "public"."company_presets_preferences" add constraint "check_valid_tags" CHECK (check_valid_tags(tags, company_preset)) not valid;

alter table "public"."company_presets_preferences" validate constraint "check_valid_tags";

alter table "public"."company_presets_preferences" add constraint "company_presets_preferences_owner_uid_check" CHECK ((auth.uid() = owner_uid)) not valid;

alter table "public"."company_presets_preferences" validate constraint "company_presets_preferences_owner_uid_check";

alter table "public"."user_information" add constraint "user_information_uid_check" CHECK ((auth.uid() = uid)) not valid;

alter table "public"."user_information" validate constraint "user_information_uid_check";

UPDATE public.company_presets SET tags = '{}';

alter table "public"."company_presets" alter column "tags" set data type session_presets_tags[] using "tags"::session_presets_tags[];

INSERT INTO public.company_presets (uid, name, phone_type, tags)
VALUES 
  (
    gen_random_uuid(),
    'Solo' ,
    'polymorphic_solo',
    ARRAY['hold_to_speak', 'tap_to_speak', 'no_seating', 'deactivated_notes', 'multi_focal_notes']::session_presets_tags[]
  );


BEGIN;

UPDATE public.company_presets
SET tags = ARRAY['tap_to_speak', 'flexible_seating', 'multi_focal_notes']::session_presets_tags[]
WHERE name = 'Collaboration';

UPDATE public.company_presets
SET tags = ARRAY['hold_to_speak', 'strict_seating', 'mono_focal_notes']::session_presets_tags[]
WHERE name = 'Consultation';

COMMIT;

alter table "public"."company_presets_preferences" alter column "owner_uid" set default auth.uid();

alter table "public"."company_presets_preferences" alter column "uid" set default gen_random_uuid();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_valid_tags(preference_tags session_presets_tags[], company_preset_uid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    company_preset_tags session_presets_tags[];
BEGIN
    SELECT tags INTO company_preset_tags
    FROM public.company_presets
    WHERE uid = company_preset_uid;

    RETURN preference_tags <@ company_preset_tags;
END;
$function$
;

alter table "public"."company_presets_preferences" add constraint "company_presets_preferences_tags_check" CHECK ((array_length(tags, 1) = 3)) not valid;

alter table "public"."company_presets_preferences" validate constraint "company_presets_preferences_tags_check";

alter table "public"."company_presets_preferences" drop constraint "company_presets_preferences_tags_check";

UPDATE public.company_presets
SET 
    tags = ARRAY['hold_to_speak', 'tap_to_speak', 'deactivated_notes', 'multi_focal_notes']::session_presets_tags[]
WHERE name = 'Solo';
