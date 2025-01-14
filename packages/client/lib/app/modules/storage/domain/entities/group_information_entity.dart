import 'package:equatable/equatable.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class GroupInformationEntity extends Equatable {
  final List groupMembers;
  final String groupName;
  final String groupHandle;
  final int groupId;
  final List<CollaboratorEntity> collaborators;

  const GroupInformationEntity({
    required this.groupMembers,
    required this.groupName,
    required this.groupHandle,
    required this.groupId,
    required this.collaborators,
  });

  factory GroupInformationEntity.empty() => const GroupInformationEntity(
        groupMembers: [],
        groupName: '',
        groupHandle: '',
        groupId: -1,
        collaborators: [],
      );

  @override
  List<Object> get props => [
        groupMembers,
        groupName,
        groupHandle,
        groupId,
        collaborators,
      ];
}
