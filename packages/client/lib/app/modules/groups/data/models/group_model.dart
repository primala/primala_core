import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.groupId,
    required super.groupName,
    required super.isAdmin,
    required super.profileGradient,
  });

  static List<GroupModel> fromSupabase(List groupResponse) {
    if (groupResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupModel> groups = <GroupModel>[];
      for (var group in groupResponse) {
        groups.add(
          GroupModel(
            groupId: group[GroupsQueries.ID],
            groupName: group[GroupsQueries.GROUP_NAME],
            isAdmin: group[GroupsQueries.IS_ADMIN],
            profileGradient: ProfileGradientUtils.mapStringToProfileGradient(
              group[GroupsQueries.GRADIENT],
            ),
          ),
        );
      }
      return groups;
    }
  }
}
