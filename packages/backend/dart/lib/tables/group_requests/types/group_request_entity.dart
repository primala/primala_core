import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

typedef GroupRequests = List<GroupRequestEntity>;

class GroupRequestEntity extends Equatable {
  final int id;
  final ProfileGradient senderProfileGradient;
  final String senderFullName;
  final String groupName;
  final String sentAt;

  const GroupRequestEntity({
    required this.id,
    required this.senderFullName,
    required this.groupName,
    required this.sentAt,
    required this.senderProfileGradient,
  });

  @override
  List<Object> get props => [
        id,
        senderFullName,
        groupName,
        sentAt,
      ];

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  static GroupRequestEntity fromSupabase(Map res) {
    if (res.isEmpty) {
      return const GroupRequestEntity(
        id: 0,
        senderFullName: '',
        groupName: '',
        senderProfileGradient: ProfileGradient.none,
        sentAt: '',
      );
    } else {
      return GroupRequestEntity(
        id: res[GroupRequestsQueries.ID],
        senderProfileGradient: ProfileGradientUtils.mapStringToProfileGradient(
          res[GroupRequestsQueries.SENDER_PROFILE_GRADIENT],
        ),
        senderFullName: res[GroupRequestsQueries.SENDER_FULL_NAME],
        groupName: res[GroupRequestsQueries.GROUP_NAME],
        sentAt: formatRelativeTime(
            DateTime.parse(res[GroupRequestsQueries.CREATED_AT])),
      );
    }
  }
}
