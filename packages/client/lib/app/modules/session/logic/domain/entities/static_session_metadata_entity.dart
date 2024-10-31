import 'package:equatable/equatable.dart';

class NameAndUID extends Equatable {
  final String name;
  final String uid;

  const NameAndUID({
    required this.name,
    required this.uid,
  });

  @override
  List<Object> get props => [name, uid];
}

class StaticSessionMetadataEntity extends Equatable {
  final int userIndex;
  final bool isAPremiumSession;
  final bool leaderIsWhitelisted;
  final String leaderUID;
  final bool isAValidSession;
  final List<NameAndUID> namesAndUIDs;
  final String presetUID;

  const StaticSessionMetadataEntity({
    required this.userIndex,
    required this.leaderUID,
    required this.isAPremiumSession,
    required this.namesAndUIDs,
    this.leaderIsWhitelisted = false,
    this.isAValidSession = true,
    required this.presetUID,
  });

  @override
  List<Object> get props => [
        namesAndUIDs,
        userIndex,
        isAPremiumSession,
        leaderUID,
        leaderIsWhitelisted,
        isAValidSession,
        presetUID,
      ];
}
