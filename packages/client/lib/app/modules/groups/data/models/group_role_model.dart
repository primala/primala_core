import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

class GroupRoleModel extends GroupRoleEntity with ProfileGradientUtils {
  const GroupRoleModel({
    required super.userUid,
    required super.role,
    required super.profileGradient,
    required super.fullName,
  });

  static List<GroupRoleModel> fromSupabase(List roleResponse) {
    if (roleResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupRoleModel> groups = <GroupRoleModel>[];
      for (var group in roleResponse) {
        final usersRes = group[UsersConstants.S_TABLE];
        final fullName = usersRes[UsersConstants.S_FULL_NAME];
        final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
            usersRes[UsersConstants.S_GRADIENT]);
        groups.add(
          GroupRoleModel(
            userUid: group[GroupRolesQueries.USER_UID],
            role: group[GroupRolesQueries.ROLE],
            fullName: fullName,
            profileGradient: profileGradient,
          ),
        );
      }
      return groups;
    }
  }
}
