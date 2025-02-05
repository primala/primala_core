import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PreSessionRemoteSource {
  Future<Map> initializeSession(InitializeSessionParams params);
  Future<List> getGroupMembers(int groupId);
  Future<List> getDocuments(int groupId);
  String getUserUID();
}

class PreSessionRemoteSourceImpl implements PreSessionRemoteSource {
  final SupabaseClient supabase;
  final GroupRolesQueries groupRolesQueries;
  final DocumentsQueries documentsQueries;
  final SessionsQueries sessionQueries;

  PreSessionRemoteSourceImpl({required this.supabase})
      : sessionQueries = SessionsQueries(supabase: supabase),
        documentsQueries = DocumentsQueries(supabase: supabase),
        groupRolesQueries = GroupRolesQueries(supabase: supabase);

  @override
  initializeSession(params) async =>
      await sessionQueries.initializeSession(params);

  @override
  getDocuments(groupId) async => await documentsQueries.selectByGroup(groupId);

  @override
  getGroupMembers(groupId) async =>
      await groupRolesQueries.selectByGroup(groupId);

  @override
  getUserUID() => supabase.auth.currentUser?.id ?? '';
}
