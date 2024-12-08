import { serve } from "std/server";
import { supabaseAdmin } from "../constants/supabase.ts";
import { getSessionUID } from "../utils/get-session-uid.ts";
import { isNotEmptyOrNull } from "../utils/array-utils.ts";

serve(async (req) => {
  const { userUID } = await req.json();
  let returnRes = {
    status: 200,
    message: "successful nuke",
  };
  const sessionRes = (
    await supabaseAdmin
      .from("static_active_sessions")
      .select()
      .eq("leader_uid", userUID)
  )?.data;
  if (isNotEmptyOrNull(sessionRes)) {
    const sessionShouldBeNuked =
      sessionRes?.[0]["collaborator_uids"].length === 1;
    if (sessionShouldBeNuked) {
      const sessionUID = await getSessionUID(userUID);
      const { error } = await supabaseAdmin
        .from("realtime_active_sessions")
        .delete()
        .eq("session_uid", sessionUID);
      await supabaseAdmin
        .from("static_active_sessions")
        .delete()
        .eq("leader_uid", userUID);
      if (error != null) {
        returnRes = {
          status: 400,
          message: "nuke failed",
        };
      }
    }
  }

  return new Response(JSON.stringify(returnRes), {
    headers: { "Content-Type": "application/json" },
  });
});
