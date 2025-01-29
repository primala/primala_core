import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/types/types.dart';

class GroupRoleEntity extends Equatable {
  final String userUid;
  final GroupRole role;
  final String fullName;
  final int groupId;
  final ProfileGradient profileGradient;
  final bool isPending;
  final bool isUser;

  const GroupRoleEntity({
    required this.userUid,
    required this.groupId,
    required this.role,
    required this.fullName,
    required this.profileGradient,
    required this.isPending,
    required this.isUser,
  });

  @override
  List<Object> get props => [
        userUid,
        groupId,
        role,
        fullName,
        profileGradient,
        isPending,
        isUser,
      ];
}
