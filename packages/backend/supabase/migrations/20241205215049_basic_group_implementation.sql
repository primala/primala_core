
create table "public"."group_information" (
    "uid" uuid not null default gen_random_uuid(),
    "group_members" uuid[] not null,
    "group_name" text not null,
    "group_handle" text not null
);


alter table "public"."group_information" enable row level security;

CREATE UNIQUE INDEX group_information_group_handle_key ON public.group_information USING btree (group_handle);

CREATE UNIQUE INDEX group_information_pkey ON public.group_information USING btree (uid);

alter table "public"."group_information" add constraint "group_information_pkey" PRIMARY KEY using index "group_information_pkey";

alter table "public"."group_information" add constraint "group_information_group_handle_key" UNIQUE using index "group_information_group_handle_key";

grant delete on table "public"."group_information" to "anon";

grant insert on table "public"."group_information" to "anon";

grant references on table "public"."group_information" to "anon";

grant select on table "public"."group_information" to "anon";

grant trigger on table "public"."group_information" to "anon";

grant truncate on table "public"."group_information" to "anon";

grant update on table "public"."group_information" to "anon";

grant delete on table "public"."group_information" to "authenticated";

grant insert on table "public"."group_information" to "authenticated";

grant references on table "public"."group_information" to "authenticated";

grant select on table "public"."group_information" to "authenticated";

grant trigger on table "public"."group_information" to "authenticated";

grant truncate on table "public"."group_information" to "authenticated";

grant update on table "public"."group_information" to "authenticated";

grant delete on table "public"."group_information" to "service_role";

grant insert on table "public"."group_information" to "service_role";

grant references on table "public"."group_information" to "service_role";

grant select on table "public"."group_information" to "service_role";

grant trigger on table "public"."group_information" to "service_role";

grant truncate on table "public"."group_information" to "service_role";

grant update on table "public"."group_information" to "service_role";

create policy "Broad Permissions if They Are a Group Member"
on "public"."group_information"
as permissive
for all
to authenticated
using ((auth.uid() = ANY (group_members)));

