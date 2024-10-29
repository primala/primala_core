create policy "INSERT: can insert row if leader of their session"
on "public"."rt_active_nokhte_sessions"
as permissive
for insert
to authenticated
with check ((EXISTS ( SELECT st_active_nokhte_sessions.collaborator_uids
   FROM st_active_nokhte_sessions
  WHERE ((rt_active_nokhte_sessions.session_uid = st_active_nokhte_sessions.session_uid) AND (auth.uid() = st_active_nokhte_sessions.leader_uid)))));


create policy "can insert a row if they are the leader"
on "public"."st_active_nokhte_sessions"
as permissive
for insert
to authenticated
with check (((leader_uid = auth.uid()) AND (auth.uid() = ANY (collaborator_uids))));

alter table "public"."st_active_nokhte_sessions" alter column "leader_uid" set default auth.uid();