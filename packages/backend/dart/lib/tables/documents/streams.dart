import 'package:nokhte_backend/tables/content_blocks.dart';
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

  Future<ContentBlockEntity> _fetchSpotlightContent(
      int? spotlightContentId) async {
    if (spotlightContentId == null) {
      return ContentBlockEntity.initial();
    }

    final spotlightQuery = await supabase
        .from('content_blocks')
        .select()
        .eq('id', spotlightContentId)
        .single();

    return spotlightQuery.isEmpty
        ? ContentBlockEntity.initial()
        : ContentBlockEntity.fromSupabase(spotlightQuery, 0);
  }

  DocumentEntity _createDocumentEntity(
      Map<String, dynamic> doc, ContentBlockEntity spotlightContent) {
    return DocumentEntity(
      documentId: doc[ID],
      parentDocumentId: doc[PARENT_DOCUMENT_ID],
      spotlightContent: spotlightContent,
      type: mapStringToDocumentType(doc[TYPE]),
      title: doc[TITLE],
      expirationDate: doc[EXPIRATION_DATE] != null
          ? DateTime.parse(doc[EXPIRATION_DATE])
          : null,
    );
  }

  Stream<List<DocumentEntity>> _processDocumentStream(
    Stream<List<dynamic>> events,
    bool Function(List<dynamic>) filterCondition,
    bool Function() shouldBreak,
  ) async* {
    List<DocumentEntity> previousYield = [];

    await for (var event in events) {
      if (shouldBreak()) {
        break;
      }

      final documents = <DocumentEntity>[];

      if (event.isNotEmpty && filterCondition(event)) {
        for (var doc in event) {
          final spotlightContent =
              await _fetchSpotlightContent(doc[SPOTLIGHT_CONTENT_ID]);
          final document = _createDocumentEntity(doc, spotlightContent);
          documents.add(document);
        }

        if (!areListsEqual<DocumentEntity>(documents, previousYield)) {
          previousYield = List.from(documents);
          yield documents;
        }
      } else if (previousYield.isNotEmpty) {
        previousYield = [];
        yield [];
      }
    }
  }

  Stream<List<DocumentEntity>> listenToDocumentPreview(int groupId) async* {
    documentsStreamListeningStatus = true;

    final events =
        supabase.from(TABLE).stream(primaryKey: ['id']).eq(GROUP_ID, groupId);

    yield* _processDocumentStream(
      events,
      (_) => true,
      () => !documentsStreamListeningStatus || groupId == -1,
    );
  }

  Stream<List<DocumentEntity>> listenToSpecificDocuments(
      List<int> documentIds, int groupId) async* {
    documentsStreamListeningStatus = true;

    final events =
        supabase.from(TABLE).stream(primaryKey: ['id']).eq(GROUP_ID, groupId);

    yield* _processDocumentStream(
      events,
      (event) => event.any((doc) => documentIds.contains(doc[ID])),
      () => !documentsStreamListeningStatus || documentIds.isEmpty,
    );
  }
}
