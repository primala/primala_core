
CREATE UNIQUE INDEX st_active_nokhte_sessions_leader_uid_key ON public.st_active_nokhte_sessions USING btree (leader_uid);

alter table "public"."st_active_nokhte_sessions" add constraint "st_active_nokhte_sessions_leader_uid_key" UNIQUE using index "st_active_nokhte_sessions_leader_uid_key";

