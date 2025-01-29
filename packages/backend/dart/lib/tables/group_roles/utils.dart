import 'package:nokhte_backend/tables/group_roles.dart';

mixin GroupRolesUtils {
  static GroupRole mapStringToGroupRole(String role) {
    switch (role) {
      case 'admin':
        return GroupRole.admin;
      case 'collaborator':
        return GroupRole.collaborator;
      default:
        return GroupRole.none;
    }
  }

  static String mapGroupRoleToString(GroupRole role) {
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
