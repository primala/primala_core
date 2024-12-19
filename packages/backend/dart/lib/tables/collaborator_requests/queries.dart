// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRequestsQueries with CollaboratorRequestsConstants {
  final SupabaseClient supabase;

  CollaboratorRequestsQueries({
    required this.supabase,
  });

  Future<List> insert({
    required String recipientUID,
    required String senderName,
    String status = 'pending',
  }) async =>
      await supabase.from(TABLE).insert({
        SENDER_UID: supabase.auth.currentUser?.id ?? '',
        RECIPIENT_UID: recipientUID,
        STATUS: status,
        SENDER_NAME: senderName,
      }).select();

  Future<List> delete({
    required String uid,
  }) async =>
      await supabase.from(TABLE).delete().eq(UID, uid).select();

  Future<List> updateStatus({
    required String uid,
    required bool isAccepted,
  }) async =>
      await supabase
          .from(TABLE)
          .update({
            STATUS: isAccepted ? 'accepted' : 'rejected',
          })
          .eq(UID, uid)
          .select();
}
