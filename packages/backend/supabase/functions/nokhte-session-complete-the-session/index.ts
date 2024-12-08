// deno-lint-ignore-file
import { supabaseAdmin } from "../constants/supabase.ts";
import {
  isEmptyOrNull,
  isNotEmptyOrNull,
  onlyUnique,
} from "../utils/array-utils.ts";
import { serve } from "std/server";
import { isWhiteListed } from "../utils/is-whitelisted.ts";

serve(async (req) => {
  const { userUID } = await req.json();

  const stSessionRes = await supabaseAdmin
    .from("static_active_sessions")
    .select()
    .contains("collaborator_uids", `{${userUID}}`);

  const rtSessionRes = await supabaseAdmin
    .from("realtime_active_sessions")
    .select()
    .eq("session_uid", stSessionRes?.data?.[0]["session_uid"]);

  await supabaseAdmin
    .from("realtime_active_sessions")
    .delete()
    .eq("session_uid", stSessionRes?.data?.[0]["session_uid"]);

  await supabaseAdmin
    .from("static_active_sessions")
    .delete()
    .contains("collaborator_uids", `{${userUID}}`);

  let returnRes = {
    status: 200,
    message: "success",
  };

  if (isNotEmptyOrNull(stSessionRes?.data)) {
    const content = rtSessionRes?.data?.[0]["content"];
    const sessionTimestamp = stSessionRes?.data?.[0]["created_at"];
    const sessionUID = stSessionRes?.data?.[0]["session_uid"];
    const groupUID = stSessionRes?.data?.[0]["group_uid"];
    const collaboratorUIDsArr = stSessionRes?.data?.[0]["collaborator_uids"];

    const duplicateCheckRes = (
      await supabaseAdmin
        .from("finished_nokhte_sessions")
        .select()
        .contains("collaborator_uids", `{${userUID}}`)
        .eq("content", content)
    )?.data;
    if (isEmptyOrNull(duplicateCheckRes)) {
      const { error } = await supabaseAdmin
        .from("finished_nokhte_sessions")
        .insert({
          group_uid: groupUID,
          content: content,
          session_timestamp: sessionTimestamp,
          session_uid: sessionUID,
        })
        .select();

      for (let i = 0; i < collaboratorUIDsArr.length; i++) {
        const userAuthorizedViewersRes = (
          await supabaseAdmin
            .from("user_information")
            .select()
            .eq("uid", collaboratorUIDsArr[i])
        )?.data?.[0]?.["authorized_viewers"];
        const userAuthorizedViewers =
          userAuthorizedViewersRes.concat(collaboratorUIDsArr);
        const viewersMinusUserUID = userAuthorizedViewers.filter(
          (x: string) => x !== collaboratorUIDsArr[i]
        );
        const uniqueViewers = viewersMinusUserUID.filter(onlyUnique);
        uniqueViewers.sort();
        await supabaseAdmin
          .from("user_information")
          .update({
            authorized_viewers: uniqueViewers,
          })
          .eq("uid", collaboratorUIDsArr[i]);
      }

      if (error != null) {
        returnRes = {
          status: 400,
          message: "failed query",
        };
      }
    }
  }

  return new Response(JSON.stringify(returnRes), {
    headers: { "Content-Type": "application/json" },
  });
});
