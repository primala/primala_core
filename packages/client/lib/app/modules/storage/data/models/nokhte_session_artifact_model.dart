import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/finished_nokhte_sessions.dart';
import 'package:intl/intl.dart';

class NokhteSessionArtifactModel extends NokhteSessionArtifactEntity {
  const NokhteSessionArtifactModel({
    required super.title,
    required super.content,
    required super.sessionUID,
    required super.date,
  });

  static formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  static List<NokhteSessionArtifactModel> fromSupabase({
    required List nokhteSessionRes,
    required List collaboratorRowsRes,
    required String userUID,
  }) {
    List<NokhteSessionArtifactModel> temp = [];
    Set<String> uniqueContents = {};

    for (var nokhteSession in nokhteSessionRes) {
      for (var collaboratorRow in collaboratorRowsRes) {
        if ((nokhteSession[FinishedNokhteSessionQueries.COLLABORATOR_UIDS]
                    .contains(collaboratorRow["uid"]) ||
                nokhteSession[FinishedNokhteSessionQueries.COLLABORATOR_UIDS]
                    .contains(userUID)) &&
            nokhteSession[FinishedNokhteSessionQueries.CONTENT].isNotEmpty) {
          final content = nokhteSession[FinishedNokhteSessionQueries.CONTENT];
          final contentString = content.toString();

          if (uniqueContents.add(contentString)) {
            String title = '';
            final userIndex =
                nokhteSession[FinishedNokhteSessionQueries.COLLABORATOR_UIDS]
                    .indexOf(userUID);
            if (nokhteSession[FinishedNokhteSessionQueries.ALIASES][userIndex]
                .isEmpty) {
              title = 'Session with ${collaboratorRow["first_name"]}';

              if (nokhteSession[FinishedNokhteSessionQueries.COLLABORATOR_UIDS]
                      .toString() ==
                  [userUID].toString()) {
                title = 'Solo Session';
              }
            } else {
              title = nokhteSession[FinishedNokhteSessionQueries.ALIASES]
                  [userIndex];
            }
            final date = DateTime.parse(
              nokhteSession[FinishedNokhteSessionQueries.SESSION_TIMESTAMP],
            );

            temp.add(NokhteSessionArtifactModel(
              date: formatDate(date),
              title: title,
              content: content,
              sessionUID:
                  nokhteSession[FinishedNokhteSessionQueries.SESSION_UID],
            ));
          }
        }
      }
    }

    return temp;
  }
}
