import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/group_information.dart';

class GroupInformationModel extends GroupInformationEntity {
  const GroupInformationModel({
    required super.groupMembers,
    required super.groupName,
    required super.groupHandle,
    required super.groupUID,
  });

  static List<GroupInformationModel> fromSupabase(List res) {
    if (res.isEmpty) {
      return const [];
    } else {
      final List<GroupInformationModel> groups = <GroupInformationModel>[];
      for (var group in res) {
        groups.add(
          GroupInformationModel(
            groupMembers: group[GroupInformationQueries.GROUP_MEMBERS],
            groupName: group[GroupInformationQueries.GROUP_NAME],
            groupHandle: group[GroupInformationQueries.GROUP_HANDLE],
            groupUID: group[GroupInformationQueries.UID],
          ),
        );
      }
      return groups;
    }
  }
}
