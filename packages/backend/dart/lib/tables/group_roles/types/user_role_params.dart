import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles/group_roles.dart';

class UserRoleParams extends Equatable {
  final String userUid;
  final int groupId;
  final GroupRole role;

  UserRoleParams({
    required this.userUid,
    required this.groupId,
    required this.role,
  });

  @override
  List<Object> get props => [userUid, groupId, role];
}
