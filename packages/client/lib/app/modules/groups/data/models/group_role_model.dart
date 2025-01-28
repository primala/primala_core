import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

class GroupRoleModel extends GroupRoleEntity with ProfileGradientUtils {
  const GroupRoleModel({
    required super.userUid,
    required super.role,
    required super.profileGradient,
    required super.fullName,
    required super.isPending,
    required super.isUser,
  });

  static List<GroupRoleModel> fromSupabase(
    List roleResponse,
    List requestsResponse,
    String userUid,
  ) {
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
            isPending: false,
            isUser: userUid == group[GroupRolesQueries.USER_UID],
          ),
        );
      }

      for (var request in requestsResponse) {
        final fullName = request[GroupRequestsQueries.RECIPIENT_FULL_NAME];
        final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
          request[GroupRequestsQueries.RECIPIENT_PROFILE_GRADIENT],
        );
        groups.add(
          GroupRoleModel(
            userUid: request[GroupRequestsQueries.USER_UID],
            role: request[GroupRequestsQueries.GROUP_ROLE],
            fullName: fullName,
            profileGradient: profileGradient,
            isPending: true,
            isUser: userUid == request[GroupRequestsQueries.USER_UID],
          ),
        );
      }

      groups.sort((a, b) => a.fullName.compareTo(b.fullName));

      return groups;
    }
  }
}
