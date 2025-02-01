import 'package:nokhte_backend/tables/documents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DocsRemoteSource {
  Stream<DocumentEntities> listenToDocuments(int groupId);
  Future<bool> cancelDocumentStream();
}

class DocsRemoteSourceImpl extends DocsRemoteSource {
  final SupabaseClient supabase;
  final DocumentsStreams documentsStreams;

  DocsRemoteSourceImpl({required this.supabase})
      : documentsStreams = DocumentsStreams(supabase: supabase);

  @override
  Future<bool> cancelDocumentStream() async =>
      await documentsStreams.cancelDocumentStream();

  @override
  listenToDocuments(int groupId) => documentsStreams.listenToDocuments(groupId);
}
