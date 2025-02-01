// ignore_for_file: constant_identifier_names
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
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    requestsListeningStatus = false;
    return requestsListeningStatus;
  }

  Stream<SessionRequest> listenToSessionRequests(int groupId) async* {
    requestsListeningStatus = true;

    final events = supabase.from(TABLE).stream(primaryKey: ['id']).eq(
      GROUP_ID,
      groupId,
    );

    await for (var event in events) {
      if (!requestsListeningStatus) {
        break;
      }

      final filteredEvent = event.where((e) =>
          e[STATUS] ==
          mapSessionStatusToString(
            SessionStatus.recruiting,
          ));
      event = List.from(filteredEvent);

      if (filteredEvent.isNotEmpty) {
        final selectedEvent = filteredEvent.first;
        final sessionID = selectedEvent[ID];
        final sessionHost = selectedEvent[COLLABORATOR_NAMES].first;
        yield SessionRequest(id: sessionID, sessionHost: sessionHost);
      } else {
        yield SessionRequest(id: -1, sessionHost: '');
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

        yield SessionMetadata(
          userUID: userUID,
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
