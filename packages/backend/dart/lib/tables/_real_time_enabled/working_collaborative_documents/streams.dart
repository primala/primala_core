import 'package:nokhte_backend/tables/_real_time_enabled/shared/shared.dart';
import 'package:nokhte_backend/tables/working_collaborative_documents.dart';

class WorkingCollaborativeDocumentsStreams extends CollaborativeQueries {
  bool docContentListeningStatus = false;
  bool collaboratorPresenceListeningStatus = false;
  bool collaboratorDeltaListeningStatus = false;

  String userUID = '';
  WorkingCollaborativeDocumentsStreams({
    required super.supabase,
  }) {
    userUID = supabase.auth.currentUser?.id ?? '';
  }

  docContentDispose() {
    docContentListeningStatus = false;
  }

  collaboratorPresenceDispose() {
    collaboratorPresenceListeningStatus = false;
  }

  collaboratorDeltaDispose() {
    collaboratorDeltaListeningStatus = false;
  }

  Stream<DocInfoContent> docContentStream() async* {
    docContentListeningStatus = true;
    await figureOutActiveCollaboratorInfoIfNotDoneAlready();
    await for (var event in supabase
        .from('working_collaborative_documents')
        .stream(primaryKey: ['id']).eq(
      "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
      collaboratorInfo.theUsersUID,
    )) {
      final collaboratorsNumber = collaboratorInfo.theCollaboratorsNumber;
      final usersUID = collaboratorInfo.theUsersUID;
      final usersCollaboratorNumber =
          collaboratorInfo.theUsersCollaboratorNumber;
      final row = event.first;
      final bothCollaboratorsAffirm =
          row["${collaboratorsNumber}_wants_to_commit"] &&
              row["${usersCollaboratorNumber}_wants_to_commit"];
      if (!docContentListeningStatus) {
        break;
      }
      if (event.isEmpty) {
        yield DocInfoContent(
          content: "",
          lastEditWasTheUser: false,
          collaboratorsCommitDesireStatus: false,
          documentCommitStatus: false,
          userCommitDesireStatus: false,
        );
      } else {
        yield DocInfoContent(
          content: row[WorkingCollaborativeDocumentsQueries.content],
          lastEditWasTheUser:
              row[WorkingCollaborativeDocumentsQueries.lastEditedBy] ==
                  usersUID,
          collaboratorsCommitDesireStatus:
              row["${collaboratorsNumber}_wants_to_commit"],
          documentCommitStatus: bothCollaboratorsAffirm,
          userCommitDesireStatus:
              row["${usersCollaboratorNumber}_wants_to_commit"],
        );
      }
    }
  }

  Stream<CollaboratorDocInfo> getCollaboratorDocumentInfo() async* {
    collaboratorPresenceListeningStatus = true;
    await figureOutActiveCollaboratorInfoIfNotDoneAlready();
    await for (var event in supabase
        .from('working_collaborative_documents')
        .stream(primaryKey: ['id']).eq(
            "${collaboratorInfo.theUsersCollaboratorNumber}_uid",
            collaboratorInfo.theUsersUID)) {
      if (!collaboratorPresenceListeningStatus) {
        break;
      }
      if (event.isEmpty) {
        yield CollaboratorDocInfo(isPresent: false, delta: -1);
      } else {
        yield CollaboratorDocInfo(
            isPresent: event
                .first["${collaboratorInfo.theCollaboratorsNumber}_is_active"],
            delta: event
                .first["${collaboratorInfo.theCollaboratorsNumber}_delta"]);
      }
    }
  }
}
