import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageRemoteSource {
  Future<List> getSessions(String groupUID);
  Future<List> createNewGroup(CreateNewGroupParams params);
  Future<List> getGroups();
  Future<List> deleteGroup(String params);
}

class StorageRemoteSourceImpl implements StorageRemoteSource {
  final SupabaseClient supabase;
  final FinishedSessionsQueries finishedNokhteSessionQueries;
  final UserInformationQueries userNamesQueries;
  final GroupInformationQueries groupInformationQueries;
  StorageRemoteSourceImpl({required this.supabase})
      : finishedNokhteSessionQueries =
            FinishedSessionsQueries(supabase: supabase),
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
}
