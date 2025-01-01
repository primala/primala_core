import 'package:nokhte/app/modules/storage/storage.dart';

class SessionArtifactModel extends SessionArtifactEntity {
  const SessionArtifactModel({
    required super.title,
    required super.content,
    required super.sessionUID,
    required super.date,
  });

  static List<SessionArtifactModel> fromSupabase(
    List response,
  ) {
    List<SessionArtifactModel> temp = [];
    Set<String> uniqueContents = {};

    for (var session in response) {
      final content = session['FinishedSessionsQueries.CONTENT'];
      if (content.isNotEmpty) {
        final contentString = content.toString();

        if (uniqueContents.add(contentString)) {
          String title = '';
          title = '';

          temp.add(SessionArtifactModel(
            date: '',
            title: title,
            content: content,
            sessionUID: session['FinishedSessionsQueries.SESSION_UID'],
          ));
        }
      }
    }

    return temp;
  }
}
