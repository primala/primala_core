import 'package:flutter/foundation.dart';
import 'package:nokhte_backend/tables/working_collaborative_documents.dart';
import 'package:nokhte_core/custom_control_structures.dart';
import 'package:nokhte_core/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CollaborativeDocRemoteSource {
  Stream<DocInfoContent> getCollaborativeDocContent();
  Stream<CollaboratorDocInfo> getCollaboratorDocInfo();
  Future<List> createCollaborativeDoc({required String docType});
  Future<void> updateUserPresence({required bool updatedUserPresence});
  Future<void> updateUserDelta({required int updatedDelta});
  Future<void> updateCommitDesireStatus({required bool wantsToCommit});
  Future<void> updateCollaborativeDoc({
    required String newContent,
    required bool isAnUpdateFromCollaborator,
  });
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
    return streams.docContentStream();
  }

  @override
  Stream<CollaboratorDocInfo> getCollaboratorDocInfo() {
    return streams.getCollaboratorDocumentInfo();
  }

  @override
  Future<List> createCollaborativeDoc({required String docType}) async {
    await queries.figureOutActiveCollaboratorInfoIfNotDoneAlready();
    const chosenCollaboratorNumber =
        kDebugMode ? CollaboratorNumbers.two : CollaboratorNumbers.one;
    return await StringComparison.isCollaborator(
        chosenCollaboratorNumber: chosenCollaboratorNumber,
        input: queries.collaboratorInfo.theUsersCollaboratorNumber,
        callback: () async =>
            await queries.createCollaborativeDocument(docType: docType),
        elseReturnVal: []);
  }

  @override
  Future<void> updateCollaborativeDoc({
    required String newContent,
    required bool isAnUpdateFromCollaborator,
  }) async {
    return await queries.updateUsersDocContent(
      newContent: newContent,
      isAnUpdateFromCollaborator: isAnUpdateFromCollaborator,
    );
  }

  @override
  Future<void> updateUserDelta({required int updatedDelta}) async {
    return await queries.updateDelta(deltaParam: updatedDelta);
  }

  @override
  Future<void> updateUserPresence({required bool updatedUserPresence}) async {
    return await queries.updatePresence(isPresent: updatedUserPresence);
  }

  @override
  Future<void> updateCommitDesireStatus({required bool wantsToCommit}) async {
    return await queries.updateCommitDesireStatus(
        wantsToCommitParam: wantsToCommit);
  }
}
