import { serve } from "std/server";
import { supabaseAdmin } from "../constants/supabase.ts";

serve(async (req) => {
  const { wayfarerUID, queryAdjectiveID, queryNounID } = await req.json();
  const phrasesRes = await supabaseAdmin.from("collaborator_phrases").select()
    .eq("uid", wayfarerUID);
  const wayfarerAdjectiveID: string = phrasesRes.data?.[0]?.["adjective_id"];
  const wayfarerNounID: string = phrasesRes.data?.[0]?.["noun_id"];
  const poolInsertRes = await supabaseAdmin.from("p2p_collaborator_pool")
    .insert({
      "wayfarer_uid": wayfarerUID,
      "wayfarer_adjective_id": wayfarerAdjectiveID,
      "wayfarer_noun_id": wayfarerNounID,
      "query_adjective_id": queryAdjectiveID,
      "query_noun_id": queryNounID,
    }).select();
  console.log(`DATA ====> ${poolInsertRes.data}`);
  return new Response(
    JSON.stringify(poolInsertRes),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke:
# FIRST ONE
curl -i --location --request POST 'http://localhost:54321/functions/v1/searching_collaborator_inserter' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
--header 'Content-Type: application/json' \
--data '{"wayfarerUID":"ce45768c-c78b-4e59-9cc3-f593801f26da", "queryAdjectiveID": "90", "queryNounID": "140"}'
# SECOND ONE
curl -i --location --request POST 'http://localhost:54321/functions/v1/searching_collaborator_inserter' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
--header 'Content-Type: application/json' \
--data '{"wayfarerUID":"d4a2e3b6-3ed0-420c-838c-7127065e02d5", "queryAdjectiveID": "96", "queryNounID": "87"}'
*/
