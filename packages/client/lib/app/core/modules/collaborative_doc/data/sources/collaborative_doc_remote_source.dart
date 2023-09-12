import 'package:primala_backend/working_collaborative_documents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CollaborativeDocRemoteSource {
  Stream<DocInfoContent> getCollaborativeDocContent();
  Stream<int> getCollaboratorDelta();
  Stream<bool> getCollaboratorPresence();
  Future<List> createCollaborativeDoc({required String docType});
  Future<void> updateUserPresence({required bool updatedUserPresence});
  Future<void> updateUserDelta({required int updatedDelta});
  Future<void> updateCollaborativeDoc({required String newContent});
}

class CollaborativeDocRemoteSourceImpl implements CollaborativeDocRemoteSource {
  final SupabaseClient supabase;
  final String currentUserUID;
  final WorkingCollaborativeDocumentsStreams streams;
  final WorkingCollaborativeDocumentsQueries queries;

  CollaborativeDocRemoteSourceImpl({
    required this.supabase,
    required this.streams,
    required this.queries,
  }) : currentUserUID = supabase.auth.currentUser?.id ?? '';

  @override
  Stream<DocInfoContent> getCollaborativeDocContent() {
    return streams.docContentStream(
        supabase: supabase, userUID: currentUserUID);
  }

  @override
  Stream<int> getCollaboratorDelta() {
    return streams.getCollaboratorDelta(
        supabase: supabase, userUID: currentUserUID);
  }

  @override
  Stream<bool> getCollaboratorPresence() {
    return streams.isCollaboratorOnDocument(
        supabase: supabase, userUID: currentUserUID);
  }

  @override
  Future<List> createCollaborativeDoc({required String docType}) async {
    return await queries.createCollaborativeDocument(
        currentUserUID: currentUserUID, docType: 'purpose');
  }

  @override
  Future<void> updateCollaborativeDoc({required String newContent}) async {
    return await queries.updateExistingDocument(
      newContent: newContent,
    );
  }

  @override
  Future<void> updateUserDelta({required int updatedDelta}) async {
    return await queries.updateDelta(delta: updatedDelta);
  }

  @override
  Future<void> updateUserPresence({required bool updatedUserPresence}) async {
    return await queries.updatePresence(isPresent: updatedUserPresence);
  }
}
