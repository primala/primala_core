alter table "public"."rt_active_nokhte_sessions" add column "current_purpose" text not null default '""'::text;