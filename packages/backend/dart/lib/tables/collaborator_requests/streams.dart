import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollaboratorRequestsStream with CollaboratorRequestsConstants {
  final SupabaseClient supabase;

  bool collaboratorRequestsListeningStatus = false;

  CollaboratorRequestsStream({
    required this.supabase,
  });

  Future<bool> cancelRequestsListeningStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    collaboratorRequestsListeningStatus = false;
    return collaboratorRequestsListeningStatus;
  }

  Stream<List<CollaboratorRequests>> listenToCollaboratorRequests() async* {
    await for (var event in supabase.from(TABLE).stream(primaryKey: ['id'])) {
      yield event
          .map((e) => CollaboratorRequests(
                senderName: e[SENDER_NAME],
                senderUID: e[SENDER_UID],
              ))
          .toList();
    }
  }
}
