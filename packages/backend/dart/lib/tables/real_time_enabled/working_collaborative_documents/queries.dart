import 'package:primala_backend/solo_sharable_documents.dart';
import 'package:primala_backend/tables/real_time_enabled/existing_collaborations/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkingCollaborativeDocumentsQueries {
  final SupabaseClient supabase;
  String currentUserUID = '';
  CollaboratorInfo collaboratorInfo = CollaboratorInfo(
    theCollaboratorsNumber: '',
    theCollaboratorsUID: '',
    theUsersCollaboratorNumber: '',
    theUsersUID: '',
  );

  WorkingCollaborativeDocumentsQueries({required this.supabase}) {
    currentUserUID = supabase.auth.currentUser?.id ?? '';
  }

  Future<void> figureOutCollaboratorInfo() async {
    collaboratorInfo =
        await ExistingCollaborationsQueries.computeCollaboratorInfo(
      currentUserUID: currentUserUID,
      supabase: supabase,
    );
  }

  Future<void> updateExistingDocument({required String newContent}) async {
    if (collaboratorInfo.theCollaboratorsUID.isEmpty) {
      await figureOutCollaboratorInfo();
    }
    await supabase
        .from('working_collaborative_documents')
        .update({
          "content": newContent,
          "last_edited_by": currentUserUID,
        })
        .eq(
          "${collaboratorInfo.theCollaboratorsNumber}_uid",
          collaboratorInfo.theCollaboratorsUID,
        )
        .eq(
          "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
          collaboratorInfo.theUsersUID,
        );
  }

  Future<void> updatePresence({required bool isPresent}) async {
    if (collaboratorInfo.theCollaboratorsUID.isEmpty) {
      await figureOutCollaboratorInfo();
    }
    await supabase
        .from('working_collaborative_documents')
        .update({
          "${collaboratorInfo.theUsersCollaboratorNumber}_is_active": isPresent,
        })
        .eq(
          "${collaboratorInfo.theCollaboratorsNumber}_uid",
          collaboratorInfo.theCollaboratorsUID,
        )
        .eq(
          "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
          collaboratorInfo.theUsersUID,
        );
  }

  Future<void> updateDelta({required int delta}) async {
    if (collaboratorInfo.theCollaboratorsUID.isEmpty) {
      await figureOutCollaboratorInfo();
    }
    await supabase
        .from('working_collaborative_documents')
        .update({
          "${collaboratorInfo.theUsersCollaboratorNumber}_delta": delta,
        })
        .eq(
          "${collaboratorInfo.theCollaboratorsNumber}_uid",
          collaboratorInfo.theCollaboratorsUID,
        )
        .eq(
          "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
          collaboratorInfo.theUsersUID,
        );
  }

  Future<List> createCollaborativeDocument({
    required String currentUserUID,
    required String docType,
  }) async {
    if (collaboratorInfo.theCollaboratorsUID.isEmpty) {
      await figureOutCollaboratorInfo();
    }
    final checkRes = await supabase
        .from('working_collaborative_documents')
        .select()
        .eq(
          "${collaboratorInfo.theCollaboratorsNumber}_uid",
          collaboratorInfo.theCollaboratorsUID,
        )
        .eq(
          "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
          collaboratorInfo.theUsersUID,
        );

    if (checkRes.isEmpty) {
      return await supabase.from('working_collaborative_documents').insert({
        "${collaboratorInfo.theCollaboratorsNumber}_uid":
            collaboratorInfo.theCollaboratorsUID,
        "${collaboratorInfo.theUsersCollaboratorNumber}_uid":
            collaboratorInfo.theUsersUID,
        'doc_type': docType,
      }).select();
    } else {
      return [];
    }
  }
}
