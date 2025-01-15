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
    int groupId = -1,
    String? userUid,
  }) async {
    var query = supabase.from(TABLE).select();

    // Apply groupId filter if provided
    if (groupId != -1) {
      query = query.eq(GROUP_ID, groupId);
    }

    // Apply userUid filter if provided
    if (userUid != null) {
      query = query.eq(USER_UID, userUid);
    }

    return await query;
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
