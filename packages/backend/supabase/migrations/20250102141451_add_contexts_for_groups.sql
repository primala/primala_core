alter table "public"."session_information" drop constraint "session_information_group_uid_fkey";

alter table "public"."session_information" add constraint "session_information_group_uid_fkey" FOREIGN KEY (group_uid) REFERENCES group_information(uid) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."session_information" validate constraint "session_information_group_uid_fkey";

