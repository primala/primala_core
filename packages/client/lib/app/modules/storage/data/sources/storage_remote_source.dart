import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageRemoteSource {
  Future<List> createNewGroup(CreateNewGroupParams params);
  Future<List> getGroups();
  Future<List> deleteGroup(int groupId);
  Stream<GroupSessions> listenToSessions(int groupId);
  Future<List> updateSessionTitle(UpdateSessionTitleParams params);
  Future<List> createQueue(String groupUID);
  Future<List> deleteSession(int params);
  Future<List> getCollaborators();
  Future<List> updateGroupMembers(UpdateGroupMemberParams params);
  Future<bool> cancelSessionsStream();
}

class StorageRemoteSourceImpl implements StorageRemoteSource {
  final SupabaseClient supabase;
  final UsersQueries usersQueries;
  final GroupsQueries groupsQueries;
  final DormantSessionsStreams sessionStreams;
  StorageRemoteSourceImpl({required this.supabase})
      : groupsQueries = GroupsQueries(supabase: supabase),
        sessionStreams = DormantSessionsStreams(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase);

  @override
  createNewGroup(params) async => await groupsQueries.insert(
        groupName: params.groupName,
      );

  @override
  deleteGroup(groupId) async => await groupsQueries.delete(groupId);

  @override
  getGroups() async => await groupsQueries.select();

  @override
  createQueue(groupUID) async => [];

  @override
  getCollaborators() async => await usersQueries.getCollaboratorRows();

  @override
  updateGroupMembers(params) async => [];

  @override
  deleteSession(params) async => [];

  @override
  listenToSessions(groupUID) => sessionStreams.listenToSessions(groupUID);

  @override
  cancelSessionsStream() async => await sessionStreams.cancelSessionsStream();

  @override
  updateSessionTitle(params) async => [];
}
