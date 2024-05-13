import 'package:equatable/equatable.dart';

class UserJourneyInfoEntity extends Equatable {
  final bool hasGoneThroughInvitationFlow;
  final bool hasSentAnInvitation;
  final bool hasCompletedNoktheSession;
  final bool hasEnteredStorage;
  final String userUID;
  const UserJourneyInfoEntity({
    required this.hasGoneThroughInvitationFlow,
    required this.hasSentAnInvitation,
    required this.userUID,
    required this.hasCompletedNoktheSession,
    required this.hasEnteredStorage,
  });

  factory UserJourneyInfoEntity.initial() => const UserJourneyInfoEntity(
        hasGoneThroughInvitationFlow: false,
        hasSentAnInvitation: false,
        userUID: "",
        hasCompletedNoktheSession: false,
        hasEnteredStorage: false,
      );

  @override
  List<Object> get props => [
        hasGoneThroughInvitationFlow,
        hasSentAnInvitation,
        hasCompletedNoktheSession,
        hasEnteredStorage,
        userUID,
      ];
}
