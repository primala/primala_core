import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeRemoteSource {
  Stream<SessionRequest> listenToSessionRequests();
  Future<bool> cancelSessionRequestsStream();
  Future<List> joinSession(int sessionID);
  Future<List> initializeSession();
  Future<Map> getGroup(int groupId);
  Future<List> clearActiveGroup();
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final SupabaseClient supabase;
  final SessionsStreams sessionStreams;
  final SessionsQueries sessionQueries;
  final GroupsQueries groupsQueries;
  final UsersQueries usersQueries;

  HomeRemoteSourceImpl({required this.supabase})
      : sessionStreams = SessionsStreams(supabase: supabase),
        sessionQueries = SessionsQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase),
        groupsQueries = GroupsQueries(supabase: supabase);

  @override
  cancelSessionRequestsStream() async =>
      sessionStreams.cancelSessionRequestsStream();

  @override
  initializeSession() async => await sessionQueries.initializeSession();

  @override
  joinSession(sessionId) async => await sessionQueries.joinSession(sessionId);

  @override
  listenToSessionRequests() => sessionStreams.listenToSessionRequests();

  @override
  getGroup(groupId) async => await groupsQueries.select(groupId: groupId);

  @override
  clearActiveGroup() async => await usersQueries.updateActiveGroup(null);
}
