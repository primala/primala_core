// ignore_for_file: constant_identifier_names
import 'package:intl/intl.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:nokhte_backend/tables/session_information/queries.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'constants.dart';
import 'types/types.dart';

class DormantSessionInformationStreams extends SessionInformationQueries
    with SessionInformationConstants, SessionUtils {
  bool groupSessionsListeningStatus = false;
  final GroupSessions _groupSessions = GroupSessions.initial();
  final GroupInformationQueries groupInformationQueries;

  DormantSessionInformationStreams({
    required super.supabase,
  }) : groupInformationQueries = GroupInformationQueries(supabase: supabase);

  Future<bool> cancelSessionsStream() async {
    _groupSessions.dormantSessions.clear();
    _groupSessions.finishedSessions.clear();
    final res = supabase.realtime.getChannels();
    if (res.isNotEmpty) {
      await res.first.unsubscribe();
    }
    groupSessionsListeningStatus = false;
    return groupSessionsListeningStatus;
  }

  static formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  Stream<GroupSessions> listenToSessions(String groupUID) async* {
    _groupSessions.dormantSessions.clear();
    _groupSessions.finishedSessions.clear();
    groupSessionsListeningStatus = true;
    final events = supabase
        .from(TABLE)
        .stream(primaryKey: ['uid']).eq(GROUP_UID, groupUID);

    await for (var event in events) {
      if (event.isEmpty) continue;

      if (_groupSessions.finishedSessions.isEmpty &&
          _groupSessions.dormantSessions.isEmpty) {
        for (var item in event) {
          final session = SessionEntity(
            title: item[TITLE].isEmpty
                ? 'Session on ${formatDate(DateTime.parse(item[CREATED_AT]))}'
                : item[TITLE],
            uid: item[UID],
            createdAt: item[CREATED_AT],
          );

          if (item[STATUS] == 'dormant') {
            _groupSessions.dormantSessions.add(session);
          } else if (item[STATUS] == 'finished') {
            _groupSessions.finishedSessions.add(session);
          }
        }

        _groupSessions.dormantSessions.sort((a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
        _groupSessions.finishedSessions.sort((a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
      } else {
        // Handle updates
        for (var item in event) {
          final newSession = SessionEntity(
            title: item[TITLE].isEmpty
                ? 'Session on ${formatDate(DateTime.parse(item[CREATED_AT]))}'
                : item[TITLE],
            uid: item[UID],
            createdAt: item[CREATED_AT],
          );

          _groupSessions.dormantSessions.removeWhere((s) => s.uid == item[UID]);
          _groupSessions.finishedSessions
              .removeWhere((s) => s.uid == item[UID]);

          if (item[STATUS] == 'dormant') {
            _groupSessions.dormantSessions.add(newSession);
            _groupSessions.dormantSessions.sort((a, b) =>
                DateTime.parse(b.createdAt)
                    .compareTo(DateTime.parse(a.createdAt)));
          } else if (item[STATUS] == 'finished') {
            _groupSessions.finishedSessions.add(newSession);
            _groupSessions.finishedSessions.sort((a, b) =>
                DateTime.parse(b.createdAt)
                    .compareTo(DateTime.parse(a.createdAt)));
          }
        }
      }

      yield _groupSessions;
    }
  }
}
