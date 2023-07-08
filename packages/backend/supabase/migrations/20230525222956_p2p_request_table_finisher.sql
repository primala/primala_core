create policy "READ: Can Only Read Requests They've Authored" on "public"."p2p_requests" as permissive for
select to authenticated using ((sender_id = auth.uid()));
create policy "READ: Can Only Read Requests They've Received" on "public"."p2p_requests" as permissive for
select to authenticated using ((receiver_id = auth.uid()));
create policy "UPDATE: Receiver can only update the row" on "public"."p2p_requests" as permissive for
update to authenticated using (true) with check ((receiver_id = auth.uid()));