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
        await supabase.from(TABLE).select().eq(UID, params.sessionUID).single();

    return await supabase
        .from(TABLE)
        .update({
          TITLE: params.title,
          VERSION: res[VERSION] + 1,
        })
        .eq(VERSION, res[VERSION])
        .eq(UID, params.sessionUID)
        .select();
  }

  Future<List> deleteSession(String sessionUID) async =>
      await supabase.from(TABLE).delete().eq(UID, sessionUID).select();

  Future<List> initializeDormantSession(
    String groupUID,
  ) async {
    return await supabase.from(TABLE).insert({
      COLLABORATOR_UIDS: [],
      COLLABORATOR_NAMES: [],
      COLLABORATOR_STATUSES: [],
      STATUS: mapSessionStatusToString(
        SessionStatus.dormant,
      ),
      GROUP_UID: groupUID,
    }).select();
  }

  Future<List> awakenDormantSession(
    String sessionUID,
  ) async {
    return await supabase
        .from(TABLE)
        .update({
          STATUS: mapSessionStatusToString(
            SessionStatus.recruiting,
          ),
          CREATED_AT: DateTime.now().toUtc().toIso8601String()
        })
        .eq(UID, sessionUID)
        .select();
  }
}
