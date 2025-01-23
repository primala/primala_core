import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/types/types.dart';

class GroupEntity extends Equatable {
  final int groupId;
  final String groupName;
  final ProfileGradient profileGradient;
  final bool isAdmin;

  const GroupEntity({
    required this.groupId,
    required this.groupName,
    required this.isAdmin,
    required this.profileGradient,
  });

  @override
  List<Object> get props => [groupId, groupName, isAdmin, profileGradient];
}
