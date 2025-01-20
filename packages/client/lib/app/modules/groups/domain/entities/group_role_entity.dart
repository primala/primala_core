import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_roles.dart';

class GroupRoleEntity extends Equatable {
  final String userUid;
  final GroupRole role;
  final String fullName;

  const GroupRoleEntity({
    required this.userUid,
    required this.role,
    required this.fullName,
  });

  @override
  List<Object> get props => [userUid, role, fullName];
}
