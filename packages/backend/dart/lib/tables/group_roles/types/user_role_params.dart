import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles/group_roles.dart';

class UserRoleParams extends Equatable {
  final String userUID;
  final int groupID;
  final GroupRole role;

  UserRoleParams({
    required this.userUID,
    required this.groupID,
    required this.role,
  });

  @override
  List<Object> get props => [userUID, groupID, role];
}
