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
    .from("st_active_nokhte_sessions")
    .select()
    .contains("collaborator_uids", `{${userUID}}`);

  const rtSessionRes = await supabaseAdmin
    .from("rt_active_nokhte_sessions")
    .select()
    .eq("session_uid", stSessionRes?.data?.[0]["session_uid"]);

  await supabaseAdmin
    .from("rt_active_nokhte_sessions")
    .delete()
    .eq("session_uid", stSessionRes?.data?.[0]["session_uid"]);

  await supabaseAdmin
    .from("st_active_nokhte_sessions")
    .delete()
    .contains("collaborator_uids", `{${userUID}}`);

  let returnRes = {
    status: 200,
    message: "success",
  };

  if (isNotEmptyOrNull(stSessionRes?.data)) {
    const leaderUID = stSessionRes?.data?.[0]["leader_uid"];
    const content = stSessionRes?.data?.[0]["content"];
    const sessionTimestamp = stSessionRes?.data?.[0]["created_at"];
    const sessionUID = stSessionRes?.data?.[0]["session_uid"];
    let collaboratorUIDsArr = stSessionRes?.data?.[0]["collaborator_uids"];
    collaboratorUIDsArr = collaboratorUIDsArr.sort();
    // const currentPhases = rtSessionRes?.data?.[0]["current_phases"];
    const presetUID = stSessionRes?.data?.[0]["preset_uid"];

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
          collaborator_uids: collaboratorUIDsArr,
          content: content,
          session_timestamp: sessionTimestamp,
          aliases: Array(collaboratorUIDsArr.length).fill(""),
          session_uid: sessionUID,
        })
        .select();

      for (let i = 0; i < collaboratorUIDsArr.length; i++) {
        //   if (
        //     collaboratorUIDsArr.length > 3 &&
        //     currentPhases.every((e: any) => e >= 2)
        //   ) {
        //     await supabaseAdmin
        //       .from("user_metadata")
        //       .update({
        //         has_used_trial: true,
        //       })
        //       .eq("uid", collaboratorUIDsArr[i]);
        //   }

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
