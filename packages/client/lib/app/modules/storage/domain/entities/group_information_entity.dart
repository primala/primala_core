import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class GroupInformationEntity extends Equatable {
  final List groupMembers;
  final String groupName;
  final String groupHandle;
  final String groupUID;
  final List<SessionArtifactEntity> sessions;
  final List<QueueEntity> queues;

  const GroupInformationEntity({
    required this.groupMembers,
    required this.groupName,
    required this.groupHandle,
    required this.groupUID,
    required this.sessions,
    required this.queues,
  });

  factory GroupInformationEntity.empty() => const GroupInformationEntity(
        groupMembers: [],
        groupName: '',
        groupHandle: '',
        groupUID: '',
        sessions: [],
        queues: [],
      );

  @override
  List<Object> get props => [
        groupMembers,
        groupName,
        groupHandle,
        groupUID,
        sessions,
        queues,
      ];
}
