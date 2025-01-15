// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'types/types.dart';

class GroupRequestsQueries with GroupRolesUtils {
  static const TABLE = 'group_requests';
  static const ID = 'id';
  static const GROUP_ID = 'group_id';
  static const USER_UID = 'user_uid';
  static const GROUP_ROLE = 'group_role';

  final SupabaseClient supabase;
  final String userUID;

  GroupRequestsQueries({required this.supabase})
      : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> sendRequest(SendRequestParams params) async =>
      await supabase.from(TABLE).insert({
        GROUP_ID: params.groupId,
        USER_UID: userUID,
        GROUP_ROLE: mapGroupRoleToString(params.role),
      }).select();

  Future<List> select() async =>
      await supabase.from(TABLE).select().eq(USER_UID, userUID);

  Future<void> handleRequest(HandleRequestParams params) async =>
      await supabase.rpc('handle_group_request', params: {
        'p_request_id': params.requestId,
        'p_accept': params.accept,
      });
}
