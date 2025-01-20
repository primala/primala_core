// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'types/types.dart';

class GroupRequestsQueries with GroupRolesUtils {
  static const TABLE = 'group_requests';
  static const ID = 'id';
  static const GROUP_ID = 'group_id';
  static const USER_UID = 'user_uid';
  static const SENDER_FULL_NAME = 'sender_full_name';
  static const CREATED_AT = 'created_at';
  static const GROUP_NAME = 'group_name';
  static const GROUP_ROLE = 'group_role';

  final SupabaseClient supabase;
  final UsersQueries usersQueries;
  final GroupsQueries groupsQueries;
  final String userUID;

  GroupRequestsQueries({required this.supabase})
      : usersQueries = UsersQueries(supabase: supabase),
        groupsQueries = GroupsQueries(supabase: supabase),
        userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> sendRequest(SendRequestParams params) async {
    final fullName = await usersQueries.getFullName();
    final groupName = await groupsQueries.getGroupName(params.groupId);
    return await supabase.from(TABLE).insert({
      GROUP_ID: params.groupId,
      USER_UID: params.recipientUid,
      SENDER_FULL_NAME: fullName,
      GROUP_NAME: groupName,
      GROUP_ROLE: mapGroupRoleToString(params.role),
    }).select();
  }

  Future<List> select() async =>
      await supabase.from(TABLE).select().eq(USER_UID, userUID);

  Future<void> handleRequest(HandleRequestParams params) async =>
      await supabase.rpc('handle_request', params: {
        'p_request_id': params.requestId,
        'p_accept': params.accept,
      });
}
