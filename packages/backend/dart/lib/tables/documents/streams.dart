import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/sessions/utilities/utilities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentsStreams with DocumentUtils, DocumentConstants, SessionsUtils {
  final SupabaseClient supabase;
  bool documentsStreamListeningStatus = false;

  DocumentsStreams({
    required this.supabase,
  });

  Future<bool> cancelDocumentStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    documentsStreamListeningStatus = false;
    return documentsStreamListeningStatus;
  }

  Stream<DocumentEntities> listenToDocuments(int groupId) async* {
    await supabase.from(TABLE).select();
    documentsStreamListeningStatus = true;

    final events =
        supabase.from(TABLE).stream(primaryKey: [ID]).eq(GROUP_ID, groupId);

    await for (var e in events) {
      if (!documentsStreamListeningStatus) {
        break;
      }
      final temp = <DocumentEntity>[];

      if (e.isNotEmpty) {
        for (var doc in e) {
          temp.add(DocumentEntity.fromSupabase(doc));
        }
        yield temp;
      } else {
        yield [];
      }
    }
  }

  Stream<List<DocumentEntity>> listenToSpecificDocuments(
      List<int> documentIds, int groupId) async* {
    documentsStreamListeningStatus = true;

    // final events =
    //     supabase.from(TABLE).stream(primaryKey: ['id']).eq(ID, groupId);

    // yield* _processDocumentStream(
    //   events,
    //   (event) => event.any((doc) => documentIds.contains(doc[ID])),
    //   () => !documentsStreamListeningStatus || documentIds.isEmpty,
    // );
  }
}
