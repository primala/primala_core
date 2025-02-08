import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DocsRemoteSource {
  Stream<DocumentEntities> listenToDocuments(int groupId);
  Stream<DocumentEntities> listenToSpecificDocuments(List<int> documentIds);
  Future<bool> cancelDocumentStream();

  Future<Map> insertDocument(InsertDocumentParams params);
  Future<Map> deleteDocument(int documentId);
  Future<Map> updateDocumentTitle(UpdateDocumentTitleParams params);

  Future<Map> addContent(AddContentParams params);
  Future<Map> updateContent(UpdateContentParams params);
  Future<Map> updateParent(UpdateParentParams params);
  Future<Map> deleteContent(int contentId);

  Stream<ContentBlocks> listenToDocumentContent(int documentId);
  Future<bool> cancelContentStream();
}

class DocsRemoteSourceImpl extends DocsRemoteSource {
  final SupabaseClient supabase;
  final DocumentsStreams documentsStreams;
  final DocumentsQueries documentsQueries;
  final ContentBlocksQueries contentBlocksQueries;
  final ContentBlocksStreams contentBlockStreams;

  DocsRemoteSourceImpl({required this.supabase})
      : documentsStreams = DocumentsStreams(supabase: supabase),
        documentsQueries = DocumentsQueries(supabase: supabase),
        contentBlocksQueries = ContentBlocksQueries(supabase: supabase),
        contentBlockStreams = ContentBlocksStreams(supabase: supabase);

  @override
  Future<bool> cancelDocumentStream() async =>
      await documentsStreams.cancelDocumentStream();

  @override
  listenToDocuments(int groupId) => documentsStreams.listenToDocuments(groupId);

  @override
  insertDocument(params) async => await documentsQueries.insertDocument(params);

  @override
  deleteDocument(documentId) async =>
      await documentsQueries.deleteDocument(documentId);

  @override
  addContent(params) async => await contentBlocksQueries.addContent(params);

  @override
  deleteContent(contentId) async =>
      await contentBlocksQueries.deleteContent(contentId);

  @override
  updateContent(params) async =>
      await contentBlocksQueries.updateContent(params);

  @override
  updateDocumentTitle(params) async =>
      await documentsQueries.updateTitle(params);

  @override
  updateParent(params) async => await contentBlocksQueries.updateParent(params);

  @override
  cancelContentStream() async =>
      await contentBlockStreams.cancelContentListeningStream();

  @override
  listenToDocumentContent(documentId) {
    contentBlocksQueries.setDocumentId(documentId);
    return contentBlockStreams.listenToDocumentContent(documentId);
  }

  @override
  listenToSpecificDocuments(documentIds) =>
      documentsStreams.listenToSpecificDocuments(documentIds);
}
