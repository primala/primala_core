import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:intl/intl.dart';

class SessionArtifactModel extends SessionArtifactEntity {
  const SessionArtifactModel({
    required super.title,
    required super.content,
    required super.sessionUID,
    required super.date,
  });

  static formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  static List<SessionArtifactModel> fromSupabase(
    List response,
  ) {
    List<SessionArtifactModel> temp = [];
    Set<String> uniqueContents = {};

    for (var session in response) {
      final content = session[FinishedSessionsQueries.CONTENT];
      if (content.isNotEmpty) {
        final contentString = content.toString();

        if (uniqueContents.add(contentString)) {
          String title = '';
          final date = DateTime.parse(
            session[FinishedSessionsQueries.SESSION_TIMESTAMP],
          );
          title = 'Session on ${formatDate(date)}';

          temp.add(SessionArtifactModel(
            date: formatDate(date),
            title: title,
            content: content,
            sessionUID: session[FinishedSessionsQueries.SESSION_UID],
          ));
        }
      }
    }

    return temp;
  }
}
