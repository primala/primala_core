import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/session_information.dart';

class SessionMetadata extends Equatable {
  final bool userCanSpeak;
  final String sessionUID;
  final List<SessionUserInfoEntity> collaboratorInformation;
  final SessionStatus sessionStatus;
  final bool userIsSpeaking;
  final bool secondarySpotlightIsEmpty;
  final bool userIsInSecondarySpeakingSpotlight;
  final String? speakerUID;
  final DateTime speakingTimerStart;

  SessionMetadata({
    required this.sessionUID,
    required this.collaboratorInformation,
    required this.sessionStatus,
    required this.userCanSpeak,
    required this.userIsSpeaking,
    required this.secondarySpotlightIsEmpty,
    required this.speakerUID,
    required this.speakingTimerStart,
    required this.userIsInSecondarySpeakingSpotlight,
  });

  @override
  List<Object> get props => [
        userCanSpeak,
        userIsSpeaking,
        secondarySpotlightIsEmpty,
        userIsInSecondarySpeakingSpotlight,
        speakerUID ?? '',
        speakingTimerStart,
      ];
}
