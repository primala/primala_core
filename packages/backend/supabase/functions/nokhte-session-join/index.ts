import { serve } from "std/server";
import { supabaseAdmin } from "../constants/supabase.ts";

serve(async (req) => {
  const { userUID, leaderUID } = await req.json();
  let returnRes = {
    status: 200,
    message: "session successfully joined",
  };

  if (userUID !== leaderUID) {
    const { error } = await supabaseAdmin.rpc("join_session", {
      _leader_uid: leaderUID,
      _user_uid: userUID,
    });

    if (error) {
      returnRes = {
        status: 400,
        message: "Error joining session: " + error.message,
      };
    }
  } else {
    returnRes = {
      status: 409,
      message: "You cannot join your own session",
    };
  }

  return new Response(JSON.stringify(returnRes), {
    headers: { "Content-Type": "application/json" },
  });
});
