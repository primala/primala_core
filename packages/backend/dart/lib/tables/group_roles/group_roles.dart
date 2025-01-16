// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'types/types.dart';
export 'utils.dart';

class GroupRolesQueries with GroupRolesUtils {
  static const TABLE = 'group_roles';
  static const USER_UID = 'user_uid';
  static const ROLE = 'role';
  static const GROUP_ID = 'group_id';

  final SupabaseClient supabase;

  GroupRolesQueries({
    required this.supabase,
  });

  Future<List> select({
    required int groupId,
    required String userUid,
  }) async {
    return supabase
        .from(TABLE)
        .select()
        .eq(USER_UID, userUid)
        .eq(GROUP_ID, groupId);
  }

  Future<List> updateUserRole(UserRoleParams params) async => await supabase
      .from(TABLE)
      .update({
        ROLE: mapGroupRoleToString(params.role),
      })
      .eq(USER_UID, params.userUid)
      .eq(GROUP_ID, params.groupId)
      .select();

  Future<List> removeUserRole(UserRoleParams params) async => await supabase
      .from(TABLE)
      .delete()
      .eq(USER_UID, params.userUid)
      .eq(GROUP_ID, params.groupId)
      .select();
}
