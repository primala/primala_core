import 'package:equatable/equatable.dart';

class UserJourneyInfoEntity extends Equatable {
  final bool hasAccessedQrCode;
  final bool hasCompletedASession;
  final bool hasEnteredStorage;
  final bool isOnMostRecentVersion;
  final String userUID;
  const UserJourneyInfoEntity({
    required this.hasAccessedQrCode,
    required this.isOnMostRecentVersion,
    required this.userUID,
    required this.hasCompletedASession,
    required this.hasEnteredStorage,
  });

  factory UserJourneyInfoEntity.initial() => const UserJourneyInfoEntity(
        hasAccessedQrCode: false,
        userUID: "",
        hasCompletedASession: false,
        hasEnteredStorage: false,
        isOnMostRecentVersion: false,
      );

  @override
  List<Object> get props => [
        hasAccessedQrCode,
        hasCompletedASession,
        hasEnteredStorage,
        userUID,
      ];
}
