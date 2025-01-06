import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/tables/group_information.dart';
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
  final UserInformationQueries userNamesQueries;
  final GroupInformationQueries groupInformationQueries;
  final DormantSessionInformationQueries sessionInformationQueries;
  final DormantSessionInformationStreams sessionInformationStreams;
  StorageRemoteSourceImpl({required this.supabase})
      : groupInformationQueries = GroupInformationQueries(supabase: supabase),
        sessionInformationStreams =
            DormantSessionInformationStreams(supabase: supabase),
        sessionInformationQueries =
            DormantSessionInformationQueries(supabase: supabase),
        userNamesQueries = UserInformationQueries(supabase: supabase);

  @override
  createNewGroup(params) async => await groupInformationQueries.insert(
        groupName: params.groupName,
        groupHandle: params.groupHandle,
      );

  @override
  deleteGroup(params) async =>
      await groupInformationQueries.delete(uid: params);

  @override
  getGroups() async => await groupInformationQueries.select();

  @override
  createQueue(groupUID) async =>
      await sessionInformationQueries.initializeDormantSession(groupUID);

  @override
  getCollaborators() async => await userNamesQueries.getCollaboratorRows();

  @override
  updateGroupMembers(params) async =>
      await groupInformationQueries.updateGroupMembers(
        groupId: params.groupId,
        members: params.members,
        isAdding: params.isAdding,
      );

  @override
  deleteSession(params) async =>
      await sessionInformationQueries.deleteSession(params);

  @override
  listenToSessions(groupUID) =>
      sessionInformationStreams.listenToSessions(groupUID);

  @override
  cancelSessionsStream() async =>
      await sessionInformationStreams.cancelSessionsStream();

  @override
  updateSessionTitle(params) async =>
      await sessionInformationQueries.updateSessionTitle(params);
}
