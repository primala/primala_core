import 'package:nokhte_backend/tables/group_roles.dart';

mixin GroupRolesUtils {
  GroupRole mapStringToGroupRole(String role) {
    switch (role) {
      case 'admin':
        return GroupRole.admin;
      case 'collaborator':
        return GroupRole.collaborator;
      default:
        return GroupRole.none;
    }
  }

  String mapGroupRoleToString(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return 'admin';
      case GroupRole.collaborator:
        return 'collaborator';
      default:
        return 'none';
    }
  }
}
