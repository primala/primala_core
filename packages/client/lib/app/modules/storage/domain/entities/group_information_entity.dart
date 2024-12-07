import 'package:equatable/equatable.dart';

class GroupInformationEntity extends Equatable {
  final List groupMembers;
  final String groupName;
  final String groupHandle;
  final String groupUID;

  const GroupInformationEntity({
    required this.groupMembers,
    required this.groupName,
    required this.groupHandle,
    required this.groupUID,
  });

  factory GroupInformationEntity.empty() => const GroupInformationEntity(
        groupMembers: [],
        groupName: '',
        groupHandle: '',
        groupUID: '',
      );

  @override
  List<Object> get props => [
        groupMembers,
        groupName,
        groupHandle,
        groupUID,
      ];
}
