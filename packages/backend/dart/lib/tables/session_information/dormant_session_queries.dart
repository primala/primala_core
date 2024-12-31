import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utilities/utilities.dart';

class DormantSessionInformationQueries
    with
        SessionInformationConstants,
        SessionUtils,
        SessionInformationQueryUtils {
  @override
  final SupabaseClient supabase;
  final String userUID;

  final UserInformationQueries userInformationQueries;
  DormantSessionInformationQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInformationQueries = UserInformationQueries(supabase: supabase);

  Future<List> updateSessionTitle(UpdateSessionTitleParams params) async {
    final res =
        await supabase.from(TABLE).select().eq(UID, params.sessionUID).single();

    print('what is the title ${params.title} ${res[VERSION]}');
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

  Future<List> initializeDormantSession(
    String groupUID,
  ) async {
    return await supabase.from(TABLE).insert({
      COLLABORATOR_UIDS: [],
      COLLABORATOR_NAMES: [],
      COLLABORATOR_STATUSES: [],
      STATUS: SessionInformationUtils.mapSessionStatusToString(
        SessionStatus.dormant,
      ),
      GROUP_UID: groupUID,
    }).select();
  }
}
