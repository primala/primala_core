// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:nokhte_backend/tables/session_information/queries.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'constants.dart';
import 'types/types.dart';
import 'utilities/utilities.dart';

class SessionInformationStreams extends SessionInformationQueries
    with SessionInformationConstants, SessionUtils {
  bool requestsListeningStatus = false;
  bool metadataListeningStatus = false;
  bool groupSessionsListeningStatus = false;
  final Map<String, SessionRequests> _requestsCache = {};
  final GroupInformationQueries groupInformationQueries;

  SessionInformationStreams({
    required super.supabase,
  }) : groupInformationQueries = GroupInformationQueries(supabase: supabase);

  Future<bool> cancelSessionRequestsStream() async {
    resetValues();
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    _requestsCache.clear();
    requestsListeningStatus = false;
    return requestsListeningStatus;
  }

  Stream<List<SessionRequests>> listenToSessionRequests() async* {
    requestsListeningStatus = true;
    List<SessionRequests> previousYield = [];

    final events = supabase.from(TABLE).stream(primaryKey: ['id']).eq(
      STATUS,
      SessionInformationUtils.mapSessionStatusToString(
        SessionStatus.recruiting,
      ),
    );

    await for (var event in events) {
      if (!requestsListeningStatus) {
        break;
      }

      final temp = <SessionRequests>[];
      if (event.isNotEmpty) {
        for (var event in event) {
          final sessionUid = event[UID];
          if (!_requestsCache.containsKey(sessionUid)) {
            final groupName = await groupInformationQueries.getGroupName(
              event[GROUP_UID],
            );
            final res = SessionRequests(
              sessionUID: event[UID],
              groupName: groupName,
            );
            _requestsCache[sessionUid] = res;
          }
          temp.add(_requestsCache[sessionUid]!);
        }

        if (temp.isNotEmpty &&
            !areListsEqual<SessionRequests>(temp, previousYield)) {
          previousYield = List.from(temp); // Create a copy of temp
          yield temp;
        }
      } else {
        if (previousYield.isNotEmpty) {
          previousYield = [];
          _requestsCache.clear();
          yield [];
        }
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
      UID,
      sessionUID,
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
        final List<SessionUserInfoEntity> collaboratorInformation = [];

        for (var status in selectedEvent[COLLABORATOR_STATUSES]) {
          collaboratorStatuses.add(
              SessionInformationUtils.mapStringToSessionUserStatus(status));
        }
        for (var name in selectedEvent[COLLABORATOR_NAMES]) {
          collaboratorNames.add(name.toString());
        }
        for (var uid in selectedEvent[COLLABORATOR_UIDS]) {
          collaboratorUIDs.add(uid.toString());
        }

        for (int i = 0; i < collaboratorNames.length; i++) {
          collaboratorInformation.add(SessionUserInfoEntity(
            fullName: collaboratorNames[i],
            uid: collaboratorUIDs[i],
            sessionUserStatus: collaboratorStatuses[i],
          ));
        }
        final sessionStatus = SessionInformationUtils.mapStringToSessionStatus(
            selectedEvent[STATUS].toString());

        final speakingTimerStart = selectedEvent[SPEAKING_TIMER_START] == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.parse(selectedEvent[SPEAKING_TIMER_START]);

        final secondarySpotlightIsEmpty =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == null;

        final speakerUID = selectedEvent[SPEAKER_SPOTLIGHT];

        final sessionUID = selectedEvent[UID];

        final userIsInSecondarySpeakingSpotlight =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == userUID;

        final userCanSpeak = selectedEvent[SPEAKER_SPOTLIGHT] == null;
        final userIsSpeaking = selectedEvent[SPEAKER_SPOTLIGHT] == userUID;

        yield SessionMetadata(
          sessionUID: sessionUID,
          speakingTimerStart: speakingTimerStart,
          secondarySpotlightIsEmpty: secondarySpotlightIsEmpty,
          speakerUID: speakerUID,
          userIsInSecondarySpeakingSpotlight:
              userIsInSecondarySpeakingSpotlight,
          userCanSpeak: userCanSpeak,
          userIsSpeaking: userIsSpeaking,
          collaboratorInformation: collaboratorInformation,
          sessionStatus: sessionStatus,
        );
      }
    }
  }
}
