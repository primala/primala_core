import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utilities/utilities.dart';

class DormantSessionsQueries
    with SessionsConstants, SessionsUtils, SessionsQueryUtils {
  @override
  final SupabaseClient supabase;
  final String userUID;

  final UsersQueries usersQueries;
  DormantSessionsQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        usersQueries = UsersQueries(supabase: supabase);

  Future<List> updateSessionTitle(UpdateSessionTitleParams params) async {
    final res =
        await supabase.from(TABLE).select().eq(ID, params.sessionID).single();

    return await supabase
        .from(TABLE)
        .update({
          TITLE: params.title,
          VERSION: res[VERSION] + 1,
        })
        .eq(VERSION, res[VERSION])
        .eq(ID, params.sessionID)
        .select();
  }

  Future<List> deleteSession(String sessionUID) async =>
      await supabase.from(TABLE).delete().eq(ID, sessionUID).select();

  Future<List> initializeDormantSession(
    int groupID,
  ) async {
    return await supabase.from(TABLE).insert({
      COLLABORATOR_UIDS: [],
      COLLABORATOR_NAMES: [],
      COLLABORATOR_STATUSES: [],
      STATUS: mapSessionStatusToString(
        SessionStatus.dormant,
      ),
      GROUP_ID: groupID,
    }).select();
  }

  Future<List> awakenDormantSession(
    int sessionID,
  ) async {
    return await supabase
        .from(TABLE)
        .update({
          STATUS: mapSessionStatusToString(
            SessionStatus.recruiting,
          ),
          CREATED_AT: DateTime.now().toUtc().toIso8601String()
        })
        .eq(ID, sessionID)
        .select();
  }
}
