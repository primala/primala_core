import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageRemoteSource {
  Future<List> getNokhteSessionArtifacts();
  Future<List> getCollaboratorRows();
  Future<List> updateSessionAlias(UpdateSessionAliasParams params);
  String getUserUID();
  Future<List> createNewGroup(CreateNewGroupParams params);
  Future<List> getGroups();
  Future<List> deleteGroup(String params);
}

class StorageRemoteSourceImpl implements StorageRemoteSource {
  final SupabaseClient supabase;
  final FinishedNokhteSessionQueries finishedNokhteSessionQueries;
  final UserInformationQueries userNamesQueries;
  final GroupInformationQueries groupInformationQueries;
  StorageRemoteSourceImpl({required this.supabase})
      : finishedNokhteSessionQueries =
            FinishedNokhteSessionQueries(supabase: supabase),
        groupInformationQueries = GroupInformationQueries(supabase: supabase),
        userNamesQueries = UserInformationQueries(supabase: supabase);

  @override
  getNokhteSessionArtifacts() async =>
      await finishedNokhteSessionQueries.select();

  @override
  getCollaboratorRows() async => await userNamesQueries.getCollaboratorRows();

  @override
  updateSessionAlias(UpdateSessionAliasParams params) async =>
      await finishedNokhteSessionQueries.updateAlias(
        newAlias: params.newAlias,
        sessionUID: params.sessionUID,
      );

  @override
  getUserUID() => supabase.auth.currentUser?.id ?? '';

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
