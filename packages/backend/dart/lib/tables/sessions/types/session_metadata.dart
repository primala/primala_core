import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/sessions.dart';

class SessionMetadata extends Equatable {
  final bool userCanSpeak;
  final String sessionUID;
  final List<SessionUserInfoEntity> collaborators;
  final SessionStatus sessionStatus;
  final bool userIsSpeaking;
  final bool secondarySpotlightIsEmpty;
  final bool userIsInSecondarySpeakingSpotlight;
  final String? speakerUID;
  final String userUID;
  final DateTime speakingTimerStart;

  SessionMetadata({
    required this.sessionUID,
    required this.collaborators,
    required this.sessionStatus,
    required this.userCanSpeak,
    required this.userUID,
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
        collaborators,
        secondarySpotlightIsEmpty,
        userIsInSecondarySpeakingSpotlight,
        speakerUID ?? '',
        speakingTimerStart,
      ];
}
