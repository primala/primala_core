import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_requests.dart';

class GroupRequestModel extends GroupRequestEntity {
  const GroupRequestModel({
    required super.requestId,
    required super.senderFullName,
    required super.groupName,
    required super.sentAt,
  });

  static List<GroupRequestModel> fromSupabase(List requestResponse) {
    if (requestResponse.isEmpty) {
      return const [];
    } else {
      final List<GroupRequestModel> groups = <GroupRequestModel>[];
      for (var group in requestResponse) {
        groups.add(
          GroupRequestModel(
            requestId: group[GroupRequestsQueries.ID],
            senderFullName: group[GroupRequestsQueries.SENDER_FULL_NAME],
            groupName: group[GroupRequestsQueries.GROUP_NAME],
            sentAt: group[GroupRequestsQueries.CREATED_AT],
          ),
        );
      }
      return groups;
    }
  }
}
