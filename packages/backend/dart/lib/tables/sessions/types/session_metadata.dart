import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/sessions.dart';

class SessionMetadata extends Equatable {
  final bool userCanSpeak;
  final int sessionId;
  final List<SessionUserEntity> collaborators;
  final List documents;
  final int? activeDocument;
  final int groupId;
  final SessionStatus sessionStatus;
  final bool userIsSpeaking;
  final bool secondarySpotlightIsEmpty;
  final bool userIsInSecondarySpeakingSpotlight;
  final String? speakerUID;
  final String userUID;
  final DateTime speakingTimerStart;
  final PowerupType currentPowerup;

  SessionMetadata({
    required this.sessionId,
    required this.documents,
    required this.activeDocument,
    required this.currentPowerup,
    required this.collaborators,
    required this.groupId,
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
        groupId,
        documents,
        currentPowerup,
        activeDocument ?? -1,
        userIsSpeaking,
        sessionId,
        collaborators,
        secondarySpotlightIsEmpty,
        userIsInSecondarySpeakingSpotlight,
        speakerUID ?? '',
        speakingTimerStart,
      ];
}
