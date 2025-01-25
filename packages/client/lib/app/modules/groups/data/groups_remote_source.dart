import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class GroupsRemoteSource {
  Future<int> createGroup(CreateGroupParams params);
  Future<List> getGroups();
  Future<void> deleteGroup(int groupId);
  Future<List> updateGroupName(UpdateGroupNameParams params);
  Future<List> updateGroupProfileGradient(
    UpdateGroupProfileGradientParams params,
  );

  Future<List> getGroupRoles(int groupId);
  Future<List> updateUserRole(UserRoleParams params);
  Future<List> removeUserRole(UserRoleParams params);

  Future<List> sendRequest(SendRequestParams params);
  Future<void> handleRequest(HandleRequestParams params);
  Future<List> getRequests();

  Future<void> deactivateAccount();
  Future<List> updateUserProfileGradient(ProfileGradient param);
  Future<List> updateActiveGroup(int groupId);
}

class GroupsRemoteSourceImpl implements GroupsRemoteSource {
  final SupabaseClient supabase;
  final GroupsQueries groupsQueries;
  final GroupRequestsQueries groupRequestsQueries;
  final GroupRolesQueries groupRolesQueries;
  final UsersQueries usersQueries;

  GroupsRemoteSourceImpl({
    required this.supabase,
  })  : groupsQueries = GroupsQueries(supabase: supabase),
        groupRequestsQueries = GroupRequestsQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase),
        groupRolesQueries = GroupRolesQueries(supabase: supabase);

  @override
  deactivateAccount() async => await supabase.auth.signOut();

  @override
  createGroup(params) async => await groupsQueries.createGroup(params);

  @override
  deleteGroup(groupId) async => await groupsQueries.delete(groupId);

  @override
  getGroupRoles(groupId) async =>
      await groupRolesQueries.selectByGroup(groupId);

  @override
  getGroups() async => await groupsQueries.selectWithStatus();

  @override
  getRequests() async => await groupRequestsQueries.select();

  @override
  handleRequest(params) async =>
      await groupRequestsQueries.handleRequest(params);

  @override
  removeUserRole(params) async =>
      await groupRolesQueries.removeUserRole(params);

  @override
  sendRequest(params) async => await groupRequestsQueries.sendRequest(params);

  @override
  updateGroupName(params) async => await groupsQueries.updateGroupName(params);

  @override
  updateUserRole(params) async =>
      await groupRolesQueries.updateUserRole(params);

  @override
  updateActiveGroup(groupId) async =>
      await usersQueries.updateActiveGroup(groupId);

  @override
  updateGroupProfileGradient(params) async =>
      await groupsQueries.updateProfileGradient(params);

  @override
  updateUserProfileGradient(param) async =>
      await usersQueries.updateProfileGradient(param);
}
