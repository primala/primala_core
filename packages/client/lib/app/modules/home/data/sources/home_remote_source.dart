import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:nokhte_backend/tables/static_active_sessions.dart';
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
  Future<List> initializeSession(InitializeSessionParams params);
  Stream<List<SessionRequests>> listenToSessionRequests();
  Future<List> joinSession(JoinSessionParams params);
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final SupabaseClient supabase;
  final CollaboratorRequestsStream collaboratorRequestsStream;
  final CollaboratorRequestsQueries collaboratorRequestsQueries;
  final CollaboratorRelationshipsQueries collaboratorRelationshipsQueries;
  final CollaboratorRelationshipsStream collaboratorRelationshipsStream;
  final UserInformationQueries userInfoQueries;
  final StaticActiveSessionQueries staticActiveSessionQueries;
  final RealtimeActiveSessionQueries realTimeActiveSessionQueries;
  final RealtimeActiveSessionStreams realTimeActiveSessionStreams;

  HomeRemoteSourceImpl({required this.supabase})
      : collaboratorRequestsStream =
            CollaboratorRequestsStream(supabase: supabase),
        collaboratorRequestsQueries =
            CollaboratorRequestsQueries(supabase: supabase),
        collaboratorRelationshipsQueries =
            CollaboratorRelationshipsQueries(supabase: supabase),
        realTimeActiveSessionQueries =
            RealtimeActiveSessionQueries(supabase: supabase),
        realTimeActiveSessionStreams =
            RealtimeActiveSessionStreams(supabase: supabase),
        userInfoQueries = UserInformationQueries(supabase: supabase),
        staticActiveSessionQueries =
            StaticActiveSessionQueries(supabase: supabase),
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
      await staticActiveSessionQueries.initializeSession(
        groupUID: params.groupUID,
        queueUID: params.queueUID,
      );

  @override
  joinSession(params) async => await realTimeActiveSessionQueries.joinSession(
        sessionUID: params.sessionUID,
        userIndex: params.userIndex,
      );

  @override
  listenToSessionRequests() =>
      realTimeActiveSessionStreams.listenToSessionRequests().distinct();
}
