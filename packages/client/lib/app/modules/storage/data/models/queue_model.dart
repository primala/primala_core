import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:intl/intl.dart';
import 'package:nokhte_backend/tables/session_queues.dart';

class QueueModel extends QueueEntity {
  const QueueModel({
    required super.title,
    required super.content,
    required super.uid,
    required super.createdAt,
  });

  static formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  static List<QueueModel> fromSupabase(
    List response,
  ) {
    List<QueueModel> temp = [];

    for (var queue in response) {
      final date = DateTime.parse(
        queue[SessionQueuesQueries.CREATED_AT],
      );

      temp.add(QueueModel(
        createdAt: formatDate(date),
        title: queue[SessionQueuesQueries.TITLE],
        content: queue[SessionQueuesQueries.CONTENT],
        uid: queue[SessionQueuesQueries.UID],
      ));
      // }
    }

    return temp;
  }
}
