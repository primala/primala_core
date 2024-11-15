import 'package:equatable/equatable.dart';

class NokhteSessionMetadata extends Equatable {
  final bool everyoneIsOnline;
  final List phases;
  final bool sessionHasBegun;
  final bool userCanSpeak;
  final bool userIsSpeaking;
  final bool secondarySpotlightIsEmpty;
  final bool userIsInSecondarySpeakingSpotlight;
  final String? speakerUID;
  final DateTime speakingTimerStart;
  final String currentPurpose;

  NokhteSessionMetadata({
    required this.everyoneIsOnline,
    required this.phases,
    required this.userCanSpeak,
    required this.userIsSpeaking,
    required this.secondarySpotlightIsEmpty,
    required this.speakerUID,
    required this.sessionHasBegun,
    required this.speakingTimerStart,
    required this.currentPurpose,
    required this.userIsInSecondarySpeakingSpotlight,
  });

  @override
  List<Object> get props => [
        everyoneIsOnline,
        phases,
        currentPurpose,
        sessionHasBegun,
        userCanSpeak,
        userIsSpeaking,
        secondarySpotlightIsEmpty,
        userIsInSecondarySpeakingSpotlight,
        speakerUID ?? '',
        speakingTimerStart,
      ];
}
