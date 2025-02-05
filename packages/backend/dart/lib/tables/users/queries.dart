import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersQueries with UsersConstants, ProfileGradientUtils {
  final SupabaseClient supabase;
  String userUID;

  UsersQueries({
    required this.supabase,
  }) : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> insertUserInfo({
    required String fullName,
    required String email,
  }) async =>
      await supabase.from(TABLE).insert({
        UID: userUID,
        FULL_NAME: fullName,
        EMAIL: email,
      }).select();

  Future<List> updateActiveGroup(int? groupId) async => await supabase
      .from(TABLE)
      .update({
        ACTIVE_GROUP: groupId,
      })
      .eq(UID, userUID)
      .select();

  Future<Map> getUserInfo({
    String queryUID = '',
  }) async =>
      await supabase
          .from(TABLE)
          .select()
          .eq(
            UID,
            queryUID.isEmpty ? userUID : queryUID,
          )
          .single();

  Future<String> getFullName() async {
    final res = await getUserInfo();
    if (res.isNotEmpty) {
      return res[FULL_NAME];
    } else {
      return '';
    }
  }

  Future<int> getActiveGroup() async {
    final res = await getUserInfo();
    if (res.isNotEmpty && res[ACTIVE_GROUP] != null) {
      return res[ACTIVE_GROUP];
    } else {
      return -1;
    }
  }

  Future<List> updateProfileGradient(ProfileGradient param) async =>
      await supabase
          .from(TABLE)
          .update({
            GRADIENT: ProfileGradientUtils.mapProfileGradientToString(param),
          })
          .eq(UID, userUID)
          .select();

  Future<List> deleteUserInfo() async =>
      await supabase.from(TABLE).delete().eq(UID, userUID).select();

  Future<List> getCollaboratorRows() async =>
      await supabase.from(TABLE).select().neq(UID, userUID);
}
