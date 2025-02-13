import { serve } from "std/server";
import { supabaseAdmin } from "../constants/supabase.ts";

serve(async (req) => {
  const { userUid } = await req.json();
  let returnRes = {
    status: 200,
    message: "successfully deleted user",
  };

  const { error } = await supabaseAdmin.auth.admin.deleteUser(userUid);

  if (error) {
    returnRes = {
      status: 400,
      message: "failed to delete user" + error.message,
    };
  }

  return new Response(JSON.stringify(returnRes), {
    headers: { "Content-Type": "application/json" },
  });
});
