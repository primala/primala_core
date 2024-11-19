alter table "public"."rt_active_nokhte_sessions" drop column "current_purpose";

alter table "public"."rt_active_nokhte_sessions" add column "content" text[] not null default '{}'::text[];

alter table "public"."st_active_nokhte_sessions" drop column "content";
