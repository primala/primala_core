// ignore_for_file: invalid_use_of_internal_member

import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/sessions/utilities/session_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentsStreams with DocumentUtils, DocumentConstants, SessionsUtils {
  final SupabaseClient supabase;
  bool documentsStreamListeningStatus = false;

  DocumentsStreams({
    required this.supabase,
  });

  Future<bool> cancelDocumentStream() async {
    final res = supabase.realtime.getChannels();
    for (var channel in res) {
      if (channel.topic.contains(TABLE)) {
        channel.unsubscribe();
      }
    }
    documentsStreamListeningStatus = false;
    return documentsStreamListeningStatus;
  }

  Stream<DocumentEntities> listenToDocuments(int groupId) async* {
    documentsStreamListeningStatus = true;

    final events =
        supabase.from(TABLE).stream(primaryKey: ['id']).eq(GROUP_ID, groupId);

    await for (var event in events) {
      print('event: $event');
      if (!documentsStreamListeningStatus) {
        break;
      }

      yield DocumentEntity.fromSupabaseMultiple(event);
    }
  }

  Stream<List<DocumentEntity>> listenToSpecificDocuments(
      List<int> documentIds) async* {
    documentsStreamListeningStatus = true;

    final events = supabase
        .from(TABLE)
        .stream(primaryKey: ['id']).inFilter('id', documentIds);
    await for (var event in events) {
      if (!documentsStreamListeningStatus) {
        break;
      }

      yield DocumentEntity.fromSupabaseMultiple(event);
    }
  }
}
