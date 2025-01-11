import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageRemoteSource {
  Future<List> createNewGroup(CreateNewGroupParams params);
  Future<List> getGroups();
  Future<List> deleteGroup(String params);
  Stream<GroupSessions> listenToSessions(String groupUID);
  Future<List> updateSessionTitle(UpdateSessionTitleParams params);
  Future<List> createQueue(String groupUID);
  Future<List> deleteSession(String params);
  Future<List> getCollaborators();
  Future<List> updateGroupMembers(UpdateGroupMemberParams params);
  Future<bool> cancelSessionsStream();
}

class StorageRemoteSourceImpl implements StorageRemoteSource {
  final SupabaseClient supabase;
  final UsersQueries usersQueries;
  final GroupsQueries groupsQueries;
  final DormantSessionsQueries sessionQueries;
  final DormantSessionsStreams sessionStreams;
  StorageRemoteSourceImpl({required this.supabase})
      : groupsQueries = GroupsQueries(supabase: supabase),
        sessionStreams = DormantSessionsStreams(supabase: supabase),
        sessionQueries = DormantSessionsQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase);

  @override
  createNewGroup(params) async => await groupsQueries.insert(
        groupName: params.groupName,
        groupHandle: params.groupHandle,
      );

  @override
  deleteGroup(params) async => await groupsQueries.delete(uid: params);

  @override
  getGroups() async => await groupsQueries.select();

  @override
  createQueue(groupUID) async =>
      await sessionQueries.initializeDormantSession(groupUID);

  @override
  getCollaborators() async => await usersQueries.getCollaboratorRows();

  @override
  updateGroupMembers(params) async => await groupsQueries.updateGroupMembers(
        groupId: params.groupId,
        members: params.members,
        isAdding: params.isAdding,
      );

  @override
  deleteSession(params) async => await sessionQueries.deleteSession(params);

  @override
  listenToSessions(groupUID) => sessionStreams.listenToSessions(groupUID);

  @override
  cancelSessionsStream() async => await sessionStreams.cancelSessionsStream();

  @override
  updateSessionTitle(params) async =>
      await sessionQueries.updateSessionTitle(params);
}
