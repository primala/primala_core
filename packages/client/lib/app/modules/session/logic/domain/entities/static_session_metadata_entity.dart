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
  final DateTime createdAt;
  final String groupUID;
  final String queueUID;

  final String leaderUID;
  final List<NameAndUID> namesAndUIDs;
  final String presetUID;

  const StaticSessionMetadataEntity({
    required this.userIndex,
    required this.createdAt,
    required this.leaderUID,
    required this.namesAndUIDs,
    required this.presetUID,
    required this.groupUID,
    required this.queueUID,
  });

  @override
  List<Object> get props => [
        namesAndUIDs,
        userIndex,
        leaderUID,
        presetUID,
        createdAt,
        groupUID,
        queueUID,
      ];
}
