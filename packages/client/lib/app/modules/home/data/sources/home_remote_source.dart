import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeRemoteSource {
  Stream<List<UserInformationEntity>> listenToCollaboratorRelationships();
  Stream<List<CollaboratorRequests>> listenToCollaboratorRequests();
  Future<bool> cancelCollaboratorRequestsStream();
  Future<bool> cancelCollaboratorRelationshipsStream();
  Future<List> updateRequestStatus(UpdateRequestStatusParams params);
  Future<List> sendRequest(SendRequestParams params);
  Future<List> getUserInformation();
  Future<List> awakenSession(String params);
  Future<List> initializeSession(InitializeSessionParams params);
  Stream<List<SessionRequests>> listenToSessionRequests();
  Future<List> joinSession(String params);
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final SupabaseClient supabase;
  final CollaboratorRequestsStream collaboratorRequestsStream;
  final CollaboratorRequestsQueries collaboratorRequestsQueries;
  final CollaboratorRelationshipsQueries collaboratorRelationshipsQueries;
  final CollaboratorRelationshipsStream collaboratorRelationshipsStream;
  final UserInformationQueries userInfoQueries;
  final DormantSessionInformationQueries dormantSessionQueries;
  final SessionInformationStreams sessionInformationStreams;
  final SessionInformationQueries sessionInformationQueries;

  HomeRemoteSourceImpl({required this.supabase})
      : collaboratorRequestsStream =
            CollaboratorRequestsStream(supabase: supabase),
        collaboratorRequestsQueries =
            CollaboratorRequestsQueries(supabase: supabase),
        collaboratorRelationshipsQueries =
            CollaboratorRelationshipsQueries(supabase: supabase),
        dormantSessionQueries =
            DormantSessionInformationQueries(supabase: supabase),
        sessionInformationStreams =
            SessionInformationStreams(supabase: supabase),
        sessionInformationQueries =
            SessionInformationQueries(supabase: supabase),
        userInfoQueries = UserInformationQueries(supabase: supabase),
        collaboratorRelationshipsStream =
            CollaboratorRelationshipsStream(supabase: supabase);

  @override
  cancelCollaboratorRelationshipsStream() async =>
      await collaboratorRelationshipsStream
          .cancelRelationshipsListeningStream();

  @override
  cancelCollaboratorRequestsStream() async =>
      await collaboratorRequestsStream.cancelRequestsListeningStream();

  @override
  listenToCollaboratorRelationships() =>
      collaboratorRelationshipsStream.listenToCollaboratorRelationships();

  @override
  sendRequest(params) async => await collaboratorRequestsQueries.insert(
        recipientUID: params.recipientUID,
        senderName: params.senderName,
      );

  @override
  updateRequestStatus(params) async =>
      await collaboratorRequestsQueries.updateStatus(
        requestUID: params.requestUID,
        senderUID: params.senderUID,
        isAccepted: params.shouldAccept,
      );

  @override
  listenToCollaboratorRequests() =>
      collaboratorRequestsStream.listenToCollaboratorRequests();

  @override
  getUserInformation() async => await userInfoQueries.getUserInfo();

  @override
  Future<List> initializeSession(InitializeSessionParams params) async =>
      await sessionInformationQueries.initializeSession(params);
  @override
  joinSession(params) async =>
      await sessionInformationQueries.joinSession(params);

  @override
  listenToSessionRequests() =>
      sessionInformationStreams.listenToSessionRequests().distinct();

  @override
  Future<List> awakenSession(String params) async =>
      dormantSessionQueries.awakenDormantSession(params);
}
