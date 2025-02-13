
alter table "public"."users" drop constraint "user_information_uid_fkey";

alter table "public"."users" add constraint "users_uid_fkey" FOREIGN KEY (uid) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_uid_fkey";
