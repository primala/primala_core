import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_requests.dart';

typedef GroupRequests = List<GroupRequestEntity>;

class GroupRequestEntity extends Equatable {
  final int requestId;
  final String senderFullName;
  final String groupName;
  final String sentAt;

  const GroupRequestEntity({
    required this.requestId,
    required this.senderFullName,
    required this.groupName,
    required this.sentAt,
  });

  @override
  List<Object> get props => [
        requestId,
        senderFullName,
        groupName,
        sentAt,
      ];

  static GroupRequestEntity fromSupabase(Map res) {
    if (res.isEmpty) {
      return const GroupRequestEntity(
        requestId: 0,
        senderFullName: '',
        groupName: '',
        sentAt: '',
      );
    } else {
      // final List<GroupRequestEntity> groups = <GroupRequestEntity>[];
      // for (var group in requestResponse) {
      return GroupRequestEntity(
        requestId: res[GroupRequestsQueries.ID],
        senderFullName: res[GroupRequestsQueries.SENDER_FULL_NAME],
        groupName: res[GroupRequestsQueries.GROUP_NAME],
        sentAt: res[GroupRequestsQueries.CREATED_AT],
      );
      // }
      // return groups;
    }
  }
}
