import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class GroupRolesRemoteSource {
  Future<List> getGroupMembers(int groupId);
  Future<List> updateUserRole(UserRoleParams params);
  Future<List> removeUserRole(UserRoleParams params);
  Future<List> sendRequests(List<SendRequestParams> params);
  Future<Map> getUserByEmail(String email);
  Future<List> getPendingMembers(int groupId);
  String getUserUid();
}

class GroupRolesRemoteSourceImpl implements GroupRolesRemoteSource {
  final SupabaseClient supabase;
  final GroupRequestsQueries groupRequestsQueries;
  final GroupRolesQueries groupRolesQueries;
  final UsersQueries usersQueries;

  GroupRolesRemoteSourceImpl({
    required this.supabase,
  })  : groupRequestsQueries = GroupRequestsQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase),
        groupRolesQueries = GroupRolesQueries(supabase: supabase);

  @override
  getGroupMembers(groupId) async =>
      await groupRolesQueries.selectByGroup(groupId);

  @override
  removeUserRole(params) async =>
      await groupRolesQueries.removeUserRole(params);

  @override
  sendRequests(params) async => await groupRequestsQueries.sendRequests(params);

  @override
  updateUserRole(params) async =>
      await groupRolesQueries.updateUserRole(params);

  @override
  getUserUid() => supabase.auth.currentUser?.id ?? '';

  @override
  getUserByEmail(String email) async =>
      await groupRequestsQueries.getUserByEmail(email);

  @override
  getPendingMembers(groupId) async =>
      await groupRequestsQueries.getPendingMembers(groupId);
}
