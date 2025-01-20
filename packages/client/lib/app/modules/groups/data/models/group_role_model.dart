import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/users.dart';

class GroupRoleModel extends GroupRoleEntity {
  const GroupRoleModel({
    required super.userUid,
    required super.role,
    required super.fullName,
  });

  static List<GroupRoleModel> fromSupabase(List roleResponse) {
    if (roleResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupRoleModel> groups = <GroupRoleModel>[];
      for (var group in roleResponse) {
        final fullName =
            group[UsersConstants.S_TABLE][UsersConstants.S_FULL_NAME];
        groups.add(
          GroupRoleModel(
            userUid: group[GroupRolesQueries.USER_UID],
            role: group[GroupRolesQueries.ROLE],
            fullName: fullName,
          ),
        );
      }
      return groups;
    }
  }
}
