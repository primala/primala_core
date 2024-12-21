import 'package:nokhte_backend/tables/static_active_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActiveSessionEdgeFunctions with StaticActiveSessionsConstants {
  final SupabaseClient supabase;
  final String userUID;
  ActiveSessionEdgeFunctions({required this.supabase})
      : userUID = supabase.auth.currentUser?.id ?? '';
  String sessionUID = '';
  int userIndex = -1;

  computeCollaboratorInformation() async {
    if (sessionUID.isEmpty) {
      final sessionRes = await supabase
          .from("static_active_sessions")
          .select()
          .contains('collaborator_uids', '{$userUID}');
      if (sessionRes.isNotEmpty) {
        sessionUID = sessionRes.first[SESSION_UID];
        userIndex = sessionRes.first[COLLABORATOR_UIDS].indexOf(userUID);
      }
    }
  }

  Future<FunctionResponse> nukeSession() async =>
      await supabase.functions.invoke(
        'nokhte-session-nuke',
        body: {
          "userUID": userUID,
        },
      );

  Future<FunctionResponse> completeTheSession() async {
    await computeCollaboratorInformation();
    final rtRes = await supabase.from('realtime_active_sessions').select();
    final stRes = await supabase.from('static_active_sessions').select();
    if (stRes.isEmpty && rtRes.isEmpty) {
      return FunctionResponse(
          status: 200, data: {"status": 200, "message": "nothing to see here"});
    } else {
      return await supabase.functions
          .invoke('nokhte-session-complete-the-session', body: {
        'userUID': userUID,
      });
    }
  }
}
