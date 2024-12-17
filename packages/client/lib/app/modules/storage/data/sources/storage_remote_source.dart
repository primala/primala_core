import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:nokhte_backend/tables/session_queues.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageRemoteSource {
  Future<List> getSessions(String groupUID);
  Future<List> createNewGroup(CreateNewGroupParams params);
  Future<List> getGroups();
  Future<List> deleteGroup(String params);
  Future<List> getQueues(GetQueueParams params);
  Future<List> createQueue(CreateQueueParams params);
  Future<List> deleteSession(String params);
  Future<List> deleteQueue(String params);
  Future<List> getCollaborators();
  Future<List> updateGroupMembers(UpdateGroupMemberParams params);
}

class StorageRemoteSourceImpl implements StorageRemoteSource {
  final SupabaseClient supabase;
  final FinishedSessionsQueries finishedNokhteSessionQueries;
  final UserInformationQueries userNamesQueries;
  final GroupInformationQueries groupInformationQueries;
  final SessionQueuesQueries sessionQueuesQueries;
  StorageRemoteSourceImpl({required this.supabase})
      : finishedNokhteSessionQueries =
            FinishedSessionsQueries(supabase: supabase),
        sessionQueuesQueries = SessionQueuesQueries(supabase: supabase),
        groupInformationQueries = GroupInformationQueries(supabase: supabase),
        userNamesQueries = UserInformationQueries(supabase: supabase);

  @override
  getSessions(groupUID) async => await finishedNokhteSessionQueries.select(
        groupId: groupUID,
      );

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
  Future<List> createQueue(CreateQueueParams params) async =>
      await sessionQueuesQueries.insert(
        groupId: params.groupId,
        queueContent: params.content,
        queueTitle: params.title,
      );

  @override
  Future<List> deleteQueue(String params) async =>
      await sessionQueuesQueries.delete(uid: params);

  @override
  Future<List> getQueues(GetQueueParams params) async =>
      await sessionQueuesQueries.select(
        groupId: params.groupId,
        uid: params.uid,
      );

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
  deleteSession(String params) async =>
      await finishedNokhteSessionQueries.delete(params);
}
