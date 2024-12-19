import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeRemoteSource {
  String getUserUID();
  Stream<List<CollaboratorRelationshipEntity>>
      listenToCollaboratorRelationships();
  Stream<List<CollaboratorRequests>> listenToCollaboratorRequests();
  Future<bool> cancelCollaboratorRequestsStream();
  Future<bool> cancelCollaboratorRelationshipsStream();
  Future<List> updateRequestStatus(UpdateRequestStatusParams params);
  Future<List> sendRequest(SendRequestParams params);
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final SupabaseClient supabase;
  final CollaboratorRequestsStream collaboratorRequestsStream;
  final CollaboratorRequestsQueries collaboratorRequestsQueries;
  final CollaboratorRelationshipsQueries collaboratorRelationshipsQueries;
  final CollaboratorRelationshipsStream collaboratorRelationshipsStream;

  HomeRemoteSourceImpl({required this.supabase})
      : collaboratorRequestsStream =
            CollaboratorRequestsStream(supabase: supabase),
        collaboratorRequestsQueries =
            CollaboratorRequestsQueries(supabase: supabase),
        collaboratorRelationshipsQueries =
            CollaboratorRelationshipsQueries(supabase: supabase),
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
  getUserUID() => supabase.auth.currentUser?.id ?? '';

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
        uid: params.requestUID,
        isAccepted: params.shouldAccept,
      );

  @override
  listenToCollaboratorRequests() =>
      collaboratorRequestsStream.listenToCollaboratorRequests();
}
