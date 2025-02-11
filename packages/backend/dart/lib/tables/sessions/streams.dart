// ignore_for_file: constant_identifier_names, invalid_use_of_internal_member
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions/queries.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';
import 'constants.dart';
import 'types/types.dart';

class SessionsStreams extends SessionsQueries with SessionsConstants {
  bool requestsListeningStatus = false;
  bool metadataListeningStatus = false;
  bool groupSessionsListeningStatus = false;
  final GroupsQueries groupsQueries;

  SessionsStreams({
    required super.supabase,
  }) : groupsQueries = GroupsQueries(supabase: supabase);

  Future<bool> cancelSessionRequestsStream() async {
    resetValues();
    final res = supabase.realtime.getChannels();
    for (var channel in res) {
      if (channel.topic.contains(TABLE)) {
        channel.unsubscribe();
      }
    }
    requestsListeningStatus = false;
    return requestsListeningStatus;
  }

  Stream<ActiveSession> listenToActiveSessions(int groupId) async* {
    requestsListeningStatus = true;

    final events = supabase.from(TABLE).stream(primaryKey: ['id']).eq(
      GROUP_ID,
      groupId,
    );

    await for (var event in events) {
      if (!requestsListeningStatus) {
        break;
      }

      if (event.isNotEmpty) {
        final selectedEvent = event.first;
        final sessionID = selectedEvent[ID];
        final sessionHost = selectedEvent[COLLABORATOR_NAMES].first;
        final canJoin = selectedEvent[STATUS] ==
                mapSessionStatusToString(
                  SessionStatus.recruiting,
                ) &&
            selectedEvent[COLLABORATOR_UIDS].contains(userUID);
        yield ActiveSession(
            id: sessionID, sessionHost: sessionHost, canJoin: canJoin);
      } else {
        yield ActiveSession.initial();
      }
    }
  }

  Future<bool> cancelGetSessionMetadataStream() async {
    resetValues();
    await supabase.realtime.removeAllChannels();
    metadataListeningStatus = false;
    return metadataListeningStatus;
  }

  Stream<SessionMetadata> listenToPresenceMetadata() async* {
    metadataListeningStatus = true;
    resetValues();
    await findCurrentSession();

    final events = supabase.from(TABLE).stream(primaryKey: ['id']).eq(
      ID,
      sessionID,
    );
    await for (var event in events) {
      if (event.isNotEmpty) {
        if (!metadataListeningStatus) {
          break;
        }

        final selectedEvent = event.first;

        final List<SessionUserStatus> collaboratorStatuses = [];
        final List<String> collaboratorNames = [];
        final List<String> collaboratorUIDs = [];
        final List<SessionUserEntity> collaboratorInformation = [];

        for (var status in selectedEvent[COLLABORATOR_STATUSES]) {
          collaboratorStatuses.add(mapStringToSessionUserStatus(status));
        }
        for (var name in selectedEvent[COLLABORATOR_NAMES]) {
          collaboratorNames.add(name.toString());
        }
        for (var uid in selectedEvent[COLLABORATOR_UIDS]) {
          collaboratorUIDs.add(uid.toString());
        }

        for (int i = 0; i < collaboratorNames.length; i++) {
          collaboratorInformation.add(SessionUserEntity(
            profileGradient: ProfileGradientUtils.mapStringToProfileGradient(
                selectedEvent[PROFILE_GRADIENTS][i]),
            isUser: userUID == collaboratorUIDs[i],
            fullName: collaboratorNames[i],
            uid: collaboratorUIDs[i],
            sessionUserStatus: collaboratorStatuses[i],
          ));
        }
        final sessionStatus =
            mapStringToSessionStatus(selectedEvent[STATUS].toString());

        final speakingTimerStart = selectedEvent[SPEAKING_TIMER_START] == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.parse(selectedEvent[SPEAKING_TIMER_START]);

        final secondarySpotlightIsEmpty =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == null;

        final speakerUID = selectedEvent[SPEAKER_SPOTLIGHT];

        final sessionID = selectedEvent[ID];

        final userIsInSecondarySpeakingSpotlight =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == userUID;

        final userCanSpeak = selectedEvent[SPEAKER_SPOTLIGHT] == null;
        final userIsSpeaking = selectedEvent[SPEAKER_SPOTLIGHT] == userUID;

        final documents = selectedEvent[DOCUMENTS];
        final activeDocument = selectedEvent[ACTIVE_DOCUMENT];
        final groupId = selectedEvent[GROUP_ID];
        final powerup =
            mapStringToPowerupType(selectedEvent[CURRENT_POWERUP] ?? '');

        yield SessionMetadata(
          userUID: userUID,
          groupId: groupId,
          currentPowerup: powerup,
          documents: documents,
          activeDocument: activeDocument,
          sessionId: sessionID,
          speakingTimerStart: speakingTimerStart,
          secondarySpotlightIsEmpty: secondarySpotlightIsEmpty,
          speakerUID: speakerUID,
          userIsInSecondarySpeakingSpotlight:
              userIsInSecondarySpeakingSpotlight,
          userCanSpeak: userCanSpeak,
          userIsSpeaking: userIsSpeaking,
          collaborators: collaboratorInformation,
          sessionStatus: sessionStatus,
        );
      }
    }
  }
}
