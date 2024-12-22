// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRequestsQueries with CollaboratorRequestsConstants {
  final SupabaseClient supabase;
  final CollaboratorRelationshipsQueries relationshipsQueries;

  CollaboratorRequestsQueries({
    required this.supabase,
  }) : relationshipsQueries =
            CollaboratorRelationshipsQueries(supabase: supabase);

  Future<List> insert({
    required String recipientUID,
    required String senderName,
    String status = 'pending',
  }) async {
    final existingRequestRes =
        await supabase.from(TABLE).select().eq(RECIPIENT_UID, recipientUID).eq(
              SENDER_UID,
              supabase.auth.currentUser?.id ?? '',
            );
    final hasRelationship =
        await relationshipsQueries.hasRelationship(recipientUID);

    if (existingRequestRes.isNotEmpty || hasRelationship) {
      return [];
    } else {
      return await supabase.from(TABLE).insert({
        SENDER_UID: supabase.auth.currentUser?.id ?? '',
        RECIPIENT_UID: recipientUID,
        STATUS: status,
        SENDER_NAME: senderName,
      }).select();
    }
  }

  Future<List> updateStatus({
    required String requestUID,
    required String senderUID,
    required bool isAccepted,
  }) async {
    if (isAccepted) {
      await supabase.from(TABLE).delete().eq(UID, requestUID).select();
      return relationshipsQueries.insert(collaboratorTwoUid: senderUID);
    } else {
      return await supabase.from(TABLE).delete().eq(UID, requestUID).select();
    }
  }
}
