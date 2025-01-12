// ignore_for_file: constant_identifier_names
import 'package:intl/intl.dart';
import 'package:nokhte_backend/tables/sessions/queries.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'constants.dart';
import 'types/types.dart';

class DormantSessionsStreams extends SessionsQueries
    with SessionsConstants, SessionUtils {
  bool groupSessionsListeningStatus = false;
  final GroupSessions _groupSessions = GroupSessions.initial();

  DormantSessionsStreams({
    required super.supabase,
  });

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

  Stream<GroupSessions> listenToSessions(int groupUID) async* {
    _groupSessions.dormantSessions.clear();
    _groupSessions.finishedSessions.clear();
    groupSessionsListeningStatus = true;
    final events =
        supabase.from(TABLE).stream(primaryKey: ['uid']).eq(GROUP_ID, groupUID);

    await for (var event in events) {
      // if (event.isEmpty) continue;

      // Clear both lists at the start
      List<SessionEntity> dormantSessions = [];
      List<SessionEntity> finishedSessions = [];
      List<SessionEntity> recruitingSessions = [];
      List<SessionEntity> startedSessions = [];

      // Process all items
      for (var item in event) {
        final session = SessionEntity(
          title: item[TITLE].isEmpty
              ? 'Session on ${formatDate(DateTime.parse(item[CREATED_AT]))}'
              : item[TITLE],
          id: item[ID],
          createdAt: item[CREATED_AT],
        );

        if (item[STATUS] == 'dormant') {
          dormantSessions.add(session);
        } else if (item[STATUS] == 'finished') {
          finishedSessions.add(session);
        } else if (item[STATUS] == 'recruiting') {
          recruitingSessions.add(session);
        } else if (item[STATUS] == 'started') {
          startedSessions.add(session);
        }
      }

      // Sort if there are items
      if (dormantSessions.isNotEmpty) {
        dormantSessions.sort((a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
      }

      if (finishedSessions.isNotEmpty) {
        finishedSessions.sort((a, b) =>
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
      }

      // Update the group sessions with potentially empty lists
      // _groupSessions.dormantSessions = dormantSessions;
      // _groupSessions.finishedSessions = finishedSessions;

      yield GroupSessions(
        dormantSessions: dormantSessions,
        finishedSessions: finishedSessions,
        recruitingSessions: recruitingSessions,
        startedSessions: startedSessions,
      );
    }
  }
}
