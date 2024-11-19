// ignore_for_file: constant_identifier_names
import 'constants.dart';
import 'types/types.dart';
import 'queries.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class RTActiveNokhteSessionsStream extends RTActiveNokhteSessionQueries
    with RTActiveNokhteSessionsConstants {
  bool getActiveNokhteSessionCreationListingingStatus = false;
  bool sessionMetadataListeningStatus = false;

  final CompanyPresetsQueries presetsQueries;
  RTActiveNokhteSessionsStream({required super.supabase})
      : presetsQueries = CompanyPresetsQueries(supabase: supabase);

  Future<bool> cancelSessionActivationStream() async {
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    getActiveNokhteSessionCreationListingingStatus = false;
    return getActiveNokhteSessionCreationListingingStatus;
  }

  Stream<bool> listenToSessionActivationStatus() async* {
    getActiveNokhteSessionCreationListingingStatus = true;
    await for (var event in supabase.from(TABLE).stream(primaryKey: ['id'])) {
      if (!getActiveNokhteSessionCreationListingingStatus) {
        break;
      }
      if (event.isNotEmpty) {
        yield event.first[CURRENT_PHASES].length > 1;
      } else {
        yield false;
      }
    }
  }

  Future<bool> cancelGetSessionMetadataStream() async {
    await supabase.realtime.removeAllChannels();
    sessionMetadataListeningStatus = false;
    return sessionMetadataListeningStatus;
  }

  Stream<NokhteSessionMetadata> listenToPresenceMetadata() async* {
    sessionMetadataListeningStatus = true;
    await for (var event in supabase
        .from("rt_active_nokhte_sessions")
        .stream(primaryKey: ['id'])) {
      if (event.isNotEmpty) {
        if (!sessionMetadataListeningStatus) {
          break;
        }
        yield NokhteSessionMetadata(
          speakingTimerStart: event.first[SPEAKING_TIMER_START] == null
              ? DateTime.fromMillisecondsSinceEpoch(0)
              : DateTime.parse(event.first[SPEAKING_TIMER_START]),
          secondarySpotlightIsEmpty:
              event.first[SECONDARY_SPEAKER_SPOTLIGHT] == null,
          speakerUID: event.first[SPEAKER_SPOTLIGHT],
          userIsInSecondarySpeakingSpotlight:
              event.first[SECONDARY_SPEAKER_SPOTLIGHT] == userUID,
          phases: event.first[CURRENT_PHASES],
          content: event.first[CONTENT],
          userCanSpeak: event.first[SPEAKER_SPOTLIGHT] == null,
          userIsSpeaking: event.first[SPEAKER_SPOTLIGHT] == userUID,
          sessionHasBegun: event.first[HAS_BEGUN],
          everyoneIsOnline: event.first[IS_ONLINE].every((e) => e == true),
        );
      }
    }
  }
}
