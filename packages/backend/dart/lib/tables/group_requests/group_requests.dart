// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'types/types.dart';

class GroupRequestsQueries with ProfileGradientUtils {
  static const TABLE = 'group_requests';
  static const ID = 'id';
  static const GROUP_ID = 'group_id';
  static const USER_UID = 'user_uid';
  static const SENDER_FULL_NAME = 'sender_full_name';
  static const CREATED_AT = 'created_at';
  static const GROUP_NAME = 'group_name';
  static const GROUP_ROLE = 'group_role';
  static const RECIPIENT_FULL_NAME = 'recipient_full_name';
  static const SENDER_PROFILE_GRADIENT = 'sender_profile_gradient';
  static const RECIPIENT_PROFILE_GRADIENT = 'recipient_profile_gradient';

  final SupabaseClient supabase;
  final UsersQueries usersQueries;
  final GroupsQueries groupsQueries;
  final String userUID;

  GroupRequestsQueries({required this.supabase})
      : usersQueries = UsersQueries(supabase: supabase),
        groupsQueries = GroupsQueries(supabase: supabase),
        userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> sendRequests(List<SendRequestParams> params) async {
    final res = await usersQueries.getUserInfo();
    final fullName = res.first[UsersConstants.S_FULL_NAME];
    final profileGradient = res.first[UsersConstants.S_GRADIENT];
    final groupName = await groupsQueries.getGroupName(params.first.groupId);
    final responses = [];
    for (var param in params) {
      final res = await supabase.from(TABLE).insert({
        GROUP_ID: param.groupId,
        USER_UID: param.recipientUid,
        RECIPIENT_FULL_NAME: param.recipientFullName,
        SENDER_FULL_NAME: fullName,
        GROUP_NAME: groupName,
        RECIPIENT_PROFILE_GRADIENT:
            ProfileGradientUtils.mapProfileGradientToString(
          param.recipientProfileGradient,
        ),
        SENDER_PROFILE_GRADIENT: profileGradient,
        GROUP_ROLE: GroupRolesUtils.mapGroupRoleToString(param.role),
      }).select();
      responses.add(res);
    }
    return responses;
  }

  Future<Map> getUserByEmail(String email) async =>
      await supabase.rpc('get_user_by_email', params: {
        'email_to_check': email,
      });

  Future<List> getUserRequests() async =>
      await supabase.from(TABLE).select().eq(USER_UID, userUID);

  Future<List> getPendingMembers(int groupId) async =>
      await supabase.from(TABLE).select().eq(GROUP_ID, groupId);

  Future<void> handleRequest(HandleRequestParams params) async =>
      await supabase.rpc('handle_request', params: {
        'p_request_id': params.requestId,
        'p_accept': params.accept,
      });
}
