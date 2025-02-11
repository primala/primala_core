import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

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

  static List<GroupRoleEntity> fromSupabase(
    List roleResponse,
    List requestsResponse,
    String userUid,
  ) {
    if (roleResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupRoleEntity> groups = <GroupRoleEntity>[];
      for (var group in roleResponse) {
        final usersRes = group[UsersConstants.S_TABLE];
        final fullName = usersRes[UsersConstants.S_FULL_NAME];
        final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
            usersRes[UsersConstants.S_GRADIENT]);
        final groupRole = GroupRolesUtils.mapStringToGroupRole(
          group[GroupRolesQueries.ROLE],
        );
        final groupId = group[GroupRolesQueries.GROUP_ID];
        groups.add(
          GroupRoleEntity(
            userUid: group[GroupRolesQueries.USER_UID],
            groupId: groupId,
            role: groupRole,
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
        final groupRole = GroupRolesUtils.mapStringToGroupRole(
          request[GroupRequestsQueries.GROUP_ROLE],
        );
        groups.add(
          GroupRoleEntity(
            userUid: request[GroupRequestsQueries.USER_UID],
            role: groupRole,
            groupId: request[GroupRequestsQueries.GROUP_ID],
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
