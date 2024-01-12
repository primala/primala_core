import 'package:nokhte_backend/tables/_real_time_enabled/existing_collaborations/existing_collaborations.dart';
import 'package:nokhte_backend/tables/_real_time_enabled/shared/shared.dart';

class ExistingCollaborationsStream extends CollaborativeQueries {
  String userUID = '';
  ExistingCollaborationsStream({required super.supabase}) {
    userUID = supabase.auth.currentUser?.id ?? '';
  }

  bool collaboratorSearchListeningStatus = false;
  bool whoIsTalkingListeningStatus = false;

  bool isANewCollaboration(event) =>
      (event.first["collaborator_one"] == userUID ||
          event.first["collaborator_two"] == userUID) &&
      event.first["is_consecrated"] == false;

  Stream<bool> getCollaboratorSearchAndEntryStatus() async* {
    collaboratorSearchListeningStatus = true;
    await for (var event in supabase
        .from('existing_collaborations')
        .stream(primaryKey: ['id'])) {
      if (!collaboratorSearchListeningStatus) {
        break;
      }
      if (event.isNotEmpty) {
        if (isANewCollaboration(event)) {
          await ensureActiveCollaboratorInfo();
          yield true;
        } else {
          yield false;
        }
      } else {
        yield false;
      }
    }
  }

  cancelGetCollaboratorSearchStream() =>
      collaboratorSearchListeningStatus = false;

  cancelWhoIsTalkingtream() => whoIsTalkingListeningStatus = false;

  Stream<bool> checkIfCollaboratorIsTalking() async* {
    await ensureActiveCollaboratorInfo();
    whoIsTalkingListeningStatus = true;
    await for (var event in supabase
        .from('existing_collaborations')
        .stream(primaryKey: ['id']).eq(
      collaboratorInfo.theUsersCollaboratorNumber,
      collaboratorInfo.theUsersUID,
    )) {
      if (!whoIsTalkingListeningStatus) {
        break;
      }
      if (event.isEmpty) {
        yield false;
      } else if (event
          .first[ExistingCollaborationsQueries.talkingQueue].isEmpty) {
        yield false;
      } else {
        yield event.first[ExistingCollaborationsQueries.talkingQueue].first ==
            collaboratorInfo.theCollaboratorsUID;
      }
    }
  }
}
