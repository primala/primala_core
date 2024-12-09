import 'package:equatable/equatable.dart';

import 'session_artifact_entity.dart';

class GroupInformationEntity extends Equatable {
  final List groupMembers;
  final String groupName;
  final String groupHandle;
  final String groupUID;
  final List<SessionArtifactEntity> sessions;

  const GroupInformationEntity({
    required this.groupMembers,
    required this.groupName,
    required this.groupHandle,
    required this.groupUID,
    required this.sessions,
  });

  factory GroupInformationEntity.empty() => const GroupInformationEntity(
        groupMembers: [],
        groupName: '',
        groupHandle: '',
        groupUID: '',
        sessions: [],
      );

  @override
  List<Object> get props => [
        groupMembers,
        groupName,
        groupHandle,
        groupUID,
        sessions,
      ];
}
