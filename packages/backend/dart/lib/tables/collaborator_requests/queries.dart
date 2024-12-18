// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRequestsQueries with CollaboratorRequestsConstants {
  final SupabaseClient supabase;

  CollaboratorRequestsQueries({
    required this.supabase,
  });

  Future<List> insert({
    required String recipientUid,
    required String senderName,
    String status = 'pending',
  }) async =>
      await supabase.from(TABLE).insert({
        SENDER_UID: supabase.auth.currentUser?.id ?? '',
        RECIPIENT_UID: recipientUid,
        STATUS: status,
        SENDER_NAME: senderName,
      }).select();

  Future<List> delete({
    required int id,
  }) async =>
      await supabase.from(TABLE).delete().eq(ID, id).select();

  Future<List> updateStatus({
    required int id,
    required bool isAccepted,
  }) async =>
      await supabase
          .from(TABLE)
          .update({
            STATUS: isAccepted ? 'accepted' : 'rejected',
          })
          .eq(ID, id)
          .select();
}
