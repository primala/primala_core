import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final int groupId;
  final String groupName;
  final bool isAdmin;

  const GroupEntity({
    required this.groupId,
    required this.groupName,
    required this.isAdmin,
  });

  @override
  List<Object> get props => [groupId, groupName, isAdmin];
}
