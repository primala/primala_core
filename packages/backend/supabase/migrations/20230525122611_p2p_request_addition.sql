create table "public"."p2p_requests" (
    "request_id" uuid not null default gen_random_uuid(),
    "sender_id" uuid not null,
    "receiver_id" uuid not null,
    "sent_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "accepted_at" timestamp with time zone not null,
    "isAccepted" boolean not null default false
);
alter table "public"."p2p_requests" enable row level security;
CREATE UNIQUE INDEX p2p_requests_pkey ON public.p2p_requests USING btree (request_id);
alter table "public"."p2p_requests"
add constraint "p2p_requests_pkey" PRIMARY KEY using index "p2p_requests_pkey";
alter table "public"."p2p_requests"
add constraint "p2p_requests_receiver_id_fkey" FOREIGN KEY (receiver_id) REFERENCES usernames(uid) not valid;
alter table "public"."p2p_requests" validate constraint "p2p_requests_receiver_id_fkey";
alter table "public"."p2p_requests"
add constraint "p2p_requests_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES usernames(uid) not valid;
alter table "public"."p2p_requests" validate constraint "p2p_requests_sender_id_fkey";