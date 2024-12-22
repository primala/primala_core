// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/static_active_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'types/types.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class RealtimeActiveSessionStreams with RealTimeActiveSessionsConstants {
  bool requestsListeningStatus = false;
  bool metadataListeningStatus = false;
  final Map<String, SessionRequests> _requestsCache = {};

  final CompanyPresetsQueries presetsQueries;
  final StaticActiveSessionQueries staticActiveSessionQueries;
  final SupabaseClient supabase;
  final String userUID;
  RealtimeActiveSessionStreams({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        staticActiveSessionQueries =
            StaticActiveSessionQueries(supabase: supabase),
        presetsQueries = CompanyPresetsQueries(supabase: supabase);

  Future<bool> cancelSessionRequestsStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    _requestsCache.clear();
    requestsListeningStatus = false;
    return requestsListeningStatus;
  }

  bool _areListsEqual(
      List<SessionRequests> list1, List<SessionRequests> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }

  Stream<List<SessionRequests>> listenToSessionRequests() async* {
    requestsListeningStatus = true;
    List<SessionRequests> previousYield = [];

    await for (var events in supabase.from(TABLE).stream(primaryKey: ['id'])) {
      if (!requestsListeningStatus) {
        break;
      }

      final temp = <SessionRequests>[];
      if (events.isNotEmpty) {
        for (var event in events) {
          final sessionUid = event[SESSION_UID];
          if (!_requestsCache.containsKey(sessionUid)) {
            final res =
                await staticActiveSessionQueries.getRequestInfo(sessionUid);
            _requestsCache[sessionUid] = res;
          }
          temp.add(_requestsCache[sessionUid]!);
        }

        // Only yield if temp is not empty and different from previous yield
        if (temp.isNotEmpty && !_areListsEqual(temp, previousYield)) {
          previousYield = List.from(temp); // Create a copy of temp
          yield temp;
        }
      } else {
        // Only yield empty list if previous yield was non-empty
        if (previousYield.isNotEmpty) {
          previousYield = [];
          _requestsCache.clear();
          yield [];
        }
      }
    }
  }

  Future<bool> cancelGetSessionMetadataStream() async {
    await supabase.realtime.removeAllChannels();
    metadataListeningStatus = false;
    return metadataListeningStatus;
  }

  Stream<SessionMetadata> listenToPresenceMetadata() async* {
    metadataListeningStatus = true;
    await for (var event in supabase
        .from("realtime_active_sessions")
        .stream(primaryKey: ['id'])) {
      if (event.isNotEmpty) {
        if (!metadataListeningStatus) {
          break;
        }

        final eventIndex = 0;
        event.indexWhere((row) {
          final List unformatted = row[CURRENT_PHASES];
          final List phases = unformatted
            ..map((e) => double.parse(e.toString()));
          return phases.every((phase) => phase > 0.5);
        });

        if (eventIndex == -1) continue;

        final selectedEvent = event[eventIndex];

        final speakingTimerStart = selectedEvent[SPEAKING_TIMER_START] == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.parse(selectedEvent[SPEAKING_TIMER_START]);

        final secondarySpotlightIsEmpty =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == null;

        final speakerUID = selectedEvent[SPEAKER_SPOTLIGHT];

        final userIsInSecondarySpeakingSpotlight =
            selectedEvent[SECONDARY_SPEAKER_SPOTLIGHT] == userUID;

        final phases = selectedEvent[CURRENT_PHASES];
        final content = selectedEvent[CONTENT];
        final userCanSpeak = selectedEvent[SPEAKER_SPOTLIGHT] == null;
        final userIsSpeaking = selectedEvent[SPEAKER_SPOTLIGHT] == userUID;
        final sessionHasBegun = selectedEvent[HAS_BEGUN];

        final everyoneIsOnline =
            selectedEvent[IS_ONLINE].every((e) => e == true);

        yield SessionMetadata(
          speakingTimerStart: speakingTimerStart,
          secondarySpotlightIsEmpty: secondarySpotlightIsEmpty,
          speakerUID: speakerUID,
          userIsInSecondarySpeakingSpotlight:
              userIsInSecondarySpeakingSpotlight,
          phases: phases,
          content: content,
          userCanSpeak: userCanSpeak,
          userIsSpeaking: userIsSpeaking,
          sessionHasBegun: sessionHasBegun,
          everyoneIsOnline: everyoneIsOnline,
        );
      }
    }
  }
}
