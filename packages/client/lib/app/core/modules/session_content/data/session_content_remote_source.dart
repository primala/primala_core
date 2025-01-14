import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionContentRemoteSource {
  Stream<ContentBlockList> listenToDocumentContent(int documentId);
  Future<bool> cancelContentStream();
  Future<List> addContent(AddContentParams params);
  Future<List> updateContent(UpdateContentParams params);
  Future<List> updateParent(UpdateParentParams params);
  Future<List> deleteContent(int contentId);
}

class SessionContentRemoteSourceImpl implements SessionContentRemoteSource {
  final SupabaseClient supabase;
  final ContentBlocksQueries contentBlocksQueries;
  final ContentBlocksStreams contentBlockStreams;

  SessionContentRemoteSourceImpl({
    required this.supabase,
  })  : contentBlocksQueries = ContentBlocksQueries(supabase: supabase),
        contentBlockStreams = ContentBlocksStreams(supabase: supabase);

  @override
  addContent(param) async => await contentBlocksQueries.addContent(param);

  @override
  cancelContentStream() async =>
      await contentBlockStreams.cancelContentListeningStream();

  @override
  listenToDocumentContent(documentId) {
    contentBlocksQueries.setDocumentId(documentId);
    return contentBlockStreams.listenToDocumentContent(documentId);
  }

  @override
  updateContent(params) async =>
      await contentBlocksQueries.updateContent(params);

  @override
  updateParent(params) async => await contentBlocksQueries.updateParent(params);

  @override
  deleteContent(params) async =>
      await contentBlocksQueries.deleteContent(params);
}
