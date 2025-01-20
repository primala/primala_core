import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeRemoteSource {
  Stream<List<UserInformationEntity>> listenToCollaboratorRelationships();
  Stream<List<dynamic>> listenToCollaboratorRequests();
  Future<bool> cancelCollaboratorRequestsStream();
  Future<bool> cancelCollaboratorRelationshipsStream();
  Future<List> updateRequestStatus(UpdateRequestStatusParams params);
  Future<List> sendRequest(SendRequestParams params);
  Future<List> getUserInformation();
  Future<List> awakenSession(String params);
  Future<List> initializeSession();
  Stream<List<SessionRequests>> listenToSessionRequests();
  Future<List> joinSession(int sessionID);
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final SupabaseClient supabase;
  final UsersQueries userInfoQueries;
  final SessionsStreams sessionInformationStreams;
  final SessionsQueries sessionInformationQueries;

  HomeRemoteSourceImpl({required this.supabase})
      : sessionInformationStreams = SessionsStreams(supabase: supabase),
        sessionInformationQueries = SessionsQueries(supabase: supabase),
        userInfoQueries = UsersQueries(supabase: supabase);

  @override
  cancelCollaboratorRelationshipsStream() async => false;

  @override
  cancelCollaboratorRequestsStream() async => false;

  @override
  listenToCollaboratorRelationships() => const Stream.empty();

  @override
  sendRequest(params) async => [];

  @override
  updateRequestStatus(params) async => [];

  @override
  listenToCollaboratorRequests() => const Stream.empty();

  @override
  getUserInformation() async => await userInfoQueries.getUserInfo();

  @override
  Future<List> initializeSession() async =>
      await sessionInformationQueries.initializeSession();
  @override
  joinSession(sessionId) async =>
      await sessionInformationQueries.joinSession(sessionId);

  @override
  listenToSessionRequests() =>
      sessionInformationStreams.listenToSessionRequests().distinct();

  @override
  awakenSession(params) async => [];
}
