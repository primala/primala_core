// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/finished_sessions/queries.dart';
import 'package:nokhte_backend/tables/group_information.dart';

import 'shared/shared.dart';

void main() {
  late FinishedSessionQueries user1Queries;
  late GroupInformationQueries groupQueries;
  final tSetup = CommonCollaborativeTestFunctions();
  final tSessionContent = ["test1", 'test2', 'test3'];
  final now = DateTime.now().toIso8601String();
  late List<String> sortedUIDs = [];

  setUpAll(() async {
    await tSetup.setUp();
    groupQueries = GroupInformationQueries(supabase: tSetup.user1Supabase);
    sortedUIDs = [tSetup.firstUserUID, tSetup.secondUserUID];
    sortedUIDs.sort();
    user1Queries = FinishedSessionQueries(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    final res =
        (await groupQueries.select()).first[GroupInformationQueries.UID];
    await tSetup.supabaseAdmin
        .from('finished_sessions')
        .delete()
        .eq(FinishedSessionQueries.GROUP_UID, res);
  });

  test("select", () async {
    final groupId =
        (await groupQueries.select()).first[GroupInformationQueries.UID];
    await tSetup.supabaseAdmin.from("finished_sessions").insert({
      "session_uid": tSetup.firstUserUID,
      "group_uid": groupId,
      "content": tSessionContent,
      "session_timestamp": now,
    });
    await tSetup.supabaseAdmin.from("finished_sessions").insert({
      "session_uid": tSetup.secondUserUID,
      "group_uid": groupId,
      "content": tSessionContent,
      "session_timestamp": now,
    });

    final res = await user1Queries.select(groupId: groupId);
    expect(res.length, 2);
    final res2 = await user1Queries.select();
    expect(res2.length, 2);
  });
}
