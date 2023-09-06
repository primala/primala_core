create table "public"."p2p_purpose_documents" (
    "collaborator_one_uid" uuid not null,
    "collaborator_two_uid" uuid not null,
    "collaborator_one_delta" bigint not null default '-1'::integer,
    "collaborator_two_delta" bigint not null default '-1'::integer,
    "collaborator_one_is_active" boolean not null default false,
    "collaborator_two_is_active" boolean not null default false
);


alter table "public"."p2p_purpose_documents" enable row level security;

alter table "public"."p2p_purpose_documents" add constraint "p2p_purpose_documents_collaborator_one_uid_fkey" FOREIGN KEY (collaborator_one_uid) REFERENCES auth.users(id) not valid;

alter table "public"."p2p_purpose_documents" validate constraint "p2p_purpose_documents_collaborator_one_uid_fkey";

alter table "public"."p2p_purpose_documents" add constraint "p2p_purpose_documents_collaborator_two_uid_fkey" FOREIGN KEY (collaborator_two_uid) REFERENCES auth.users(id) not valid;

alter table "public"."p2p_purpose_documents" validate constraint "p2p_purpose_documents_collaborator_two_uid_fkey";

alter
  publication supabase_realtime add table public.p2p_purpose_documents;
-- some other new stuff
alter table "public"."p2p_purpose_documents" drop constraint "p2p_purpose_documents_collaborator_one_uid_fkey";

alter table "public"."p2p_purpose_documents" drop constraint "p2p_purpose_documents_collaborator_two_uid_fkey";

drop table "public"."p2p_purpose_documents";

create table "public"."finished_collaborative_p2p_purpose_documents" (
    "id" bigint generated by default as identity not null,
    "collaborator_one_uid" uuid not null,
    "collaborator_two_uid" uuid,
    "content" text,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."finished_collaborative_p2p_purpose_documents" enable row level security;

create table "public"."solo_p2p_purpose_documents" (
    "owner_uid" uuid not null,
    "collaborator_uid" uuid not null,
    "content" text not null default ''::text,
    "is_visible_to_collaborator" boolean not null default false,
    "session_is_completed" boolean not null default false
);


alter table "public"."solo_p2p_purpose_documents" enable row level security;

create table "public"."working_collaborative_p2p_purpose_documents" (
    "collaborator_one_uid" uuid not null,
    "collaborator_two_uid" uuid not null,
    "collaborator_one_delta" bigint not null default '-1'::integer,
    "collaborator_two_delta" bigint not null default '-1'::integer,
    "collaborator_one_is_active" boolean not null default false,
    "collaborator_two_is_active" boolean not null default false,
    "id" bigint generated by default as identity not null,
    "is_committed" boolean not null default false,
    "content" text not null default ''''''::text
);


alter table "public"."working_collaborative_p2p_purpose_documents" enable row level security;

CREATE UNIQUE INDEX finished_collaborative_p2p_purpose_documents_pkey ON public.finished_collaborative_p2p_purpose_documents USING btree (id);

CREATE UNIQUE INDEX p2p_purpose_documents_id_key ON public.working_collaborative_p2p_purpose_documents USING btree (id);

CREATE UNIQUE INDEX p2p_purpose_documents_pkey ON public.working_collaborative_p2p_purpose_documents USING btree (id);

alter table "public"."finished_collaborative_p2p_purpose_documents" add constraint "finished_collaborative_p2p_purpose_documents_pkey" PRIMARY KEY using index "finished_collaborative_p2p_purpose_documents_pkey";

alter table "public"."working_collaborative_p2p_purpose_documents" add constraint "p2p_purpose_documents_pkey" PRIMARY KEY using index "p2p_purpose_documents_pkey";

alter table "public"."finished_collaborative_p2p_purpose_documents" add constraint "finished_collaborative_p2p_purpose_documents_collaborator_one_u" FOREIGN KEY (collaborator_one_uid) REFERENCES auth.users(id) not valid;

alter table "public"."finished_collaborative_p2p_purpose_documents" validate constraint "finished_collaborative_p2p_purpose_documents_collaborator_one_u";

alter table "public"."finished_collaborative_p2p_purpose_documents" add constraint "finished_collaborative_p2p_purpose_documents_collaborator_two_u" FOREIGN KEY (collaborator_two_uid) REFERENCES auth.users(id) not valid;

alter table "public"."finished_collaborative_p2p_purpose_documents" validate constraint "finished_collaborative_p2p_purpose_documents_collaborator_two_u";

alter table "public"."solo_p2p_purpose_documents" add constraint "solo_p2p_purpose_documents_collaborator_uid_fkey" FOREIGN KEY (collaborator_uid) REFERENCES auth.users(id) not valid;

alter table "public"."solo_p2p_purpose_documents" validate constraint "solo_p2p_purpose_documents_collaborator_uid_fkey";

alter table "public"."solo_p2p_purpose_documents" add constraint "solo_p2p_purpose_documents_owner_uid_fkey" FOREIGN KEY (owner_uid) REFERENCES auth.users(id) not valid;

alter table "public"."solo_p2p_purpose_documents" validate constraint "solo_p2p_purpose_documents_owner_uid_fkey";

alter table "public"."working_collaborative_p2p_purpose_documents" add constraint "p2p_purpose_documents_id_key" UNIQUE using index "p2p_purpose_documents_id_key";

alter table "public"."working_collaborative_p2p_purpose_documents" add constraint "working_collaborative_p2p_purpose_documents_collaborator_one_ui" FOREIGN KEY (collaborator_one_uid) REFERENCES auth.users(id) not valid;

alter table "public"."working_collaborative_p2p_purpose_documents" validate constraint "working_collaborative_p2p_purpose_documents_collaborator_one_ui";

alter table "public"."working_collaborative_p2p_purpose_documents" add constraint "working_collaborative_p2p_purpose_documents_collaborator_two_ui" FOREIGN KEY (collaborator_two_uid) REFERENCES auth.users(id) not valid;

alter table "public"."working_collaborative_p2p_purpose_documents" validate constraint "working_collaborative_p2p_purpose_documents_collaborator_two_ui";

create policy "Users Can Read Their Own & Collaborator's Private Documents"
on "public"."solo_p2p_purpose_documents"
as permissive
for select
to authenticated
using (((auth.uid() = owner_uid) OR (EXISTS ( SELECT 1
   FROM solo_p2p_purpose_documents doc
  WHERE ((auth.uid() = doc.collaborator_uid) AND (doc.is_visible_to_collaborator = true) AND (doc.session_is_completed = false))))));


create policy "READ: Can Only Read Documents That They Are Co-Authors Of"
on "public"."working_collaborative_p2p_purpose_documents"
as permissive
for select
to authenticated
using (((auth.uid() = collaborator_one_uid) OR (auth.uid() = collaborator_two_uid)));


create policy "They Can Only Update Their Own Document"
on "public"."working_collaborative_p2p_purpose_documents"
as permissive
for update
to authenticated
using (((auth.uid() = collaborator_one_uid) OR (auth.uid() = collaborator_two_uid)));

-- session 3
drop policy "Users Can Read Their Own & Collaborator's Private Documents" on "public"."solo_p2p_purpose_documents";

create policy "Collaborators have proper read permissions"
on "public"."solo_p2p_purpose_documents"
as permissive
for select
to authenticated
using (((auth.uid() = collaborator_uid) AND (is_visible_to_collaborator = true) AND (session_is_completed = false)));


create policy "Enable insert for authenticated users only"
on "public"."solo_p2p_purpose_documents"
as permissive
for insert
to authenticated
with check (true);


create policy "Only Owners Can Update Row Information"
on "public"."solo_p2p_purpose_documents"
as permissive
for update
to authenticated
using ((auth.uid() = owner_uid));


create policy "Users Can Read Their Own Documents"
on "public"."solo_p2p_purpose_documents"
as permissive
for select
to authenticated
using (((auth.uid() = owner_uid) AND (session_is_completed = false)));
-- phase 4
drop policy "Only Owners Can Update Row Information" on "public"."solo_p2p_purpose_documents";

alter table "public"."solo_p2p_purpose_documents" add column "id" bigint generated by default as identity not null;

CREATE UNIQUE INDEX solo_p2p_purpose_documents_pkey ON public.solo_p2p_purpose_documents USING btree (id);

alter table "public"."solo_p2p_purpose_documents" add constraint "solo_p2p_purpose_documents_pkey" PRIMARY KEY using index "solo_p2p_purpose_documents_pkey";

create policy "Only Owners Can Update Row Information"
on "public"."solo_p2p_purpose_documents"
as permissive
for update
to authenticated
using (true)
with check (true);