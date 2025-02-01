import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class GroupsRemoteSource {
  Future<int> createGroup(CreateGroupParams params);
  Future<bool> cancelGroupsStream();
  Stream<GroupEntities> listenToGroups();
  Future<void> deleteGroup(int groupId);
  Future<List> updateGroupName(UpdateGroupNameParams params);
  Future<List> updateGroupProfileGradient(
    UpdateGroupProfileGradientParams params,
  );
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
  createGroup(params) async => await groupsQueries.createGroup(params);

  @override
  deleteGroup(groupId) async => await groupsQueries.delete(groupId);

  @override
  listenToGroups() => groupsQueries.listenToGroups();

  @override
  updateGroupName(params) async => await groupsQueries.updateGroupName(params);

  @override
  updateGroupProfileGradient(params) async =>
      await groupsQueries.updateProfileGradient(params);

  @override
  cancelGroupsStream() async {
    return await groupsQueries.cancelGroupsStream();
  }
}
