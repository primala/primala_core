// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/_real_time_disabled/finished_nokhte_sessions/queries.dart';

import 'shared/shared.dart';

void main() {
  late FinishedNokhteSessionQueries user1Queries;
  final tSetup = CommonCollaborativeTestFunctions();
  final tSessionContent = ["test1", 'test2', 'test3'];
  final now = DateTime.now().toIso8601String();
  late List<String> sortedUIDs = [];

  setUpAll(() async {
    await tSetup.setUp();
    sortedUIDs = [tSetup.firstUserUID, tSetup.secondUserUID];
    sortedUIDs.sort();
    user1Queries = FinishedNokhteSessionQueries(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    await tSetup.supabaseAdmin
        .from('finished_nokhte_sessions')
        .delete()
        .eq(FinishedNokhteSessionQueries.COLLABORATOR_UIDS, sortedUIDs);
    await tSetup.supabaseAdmin
        .from('finished_nokhte_sessions')
        .delete()
        .eq(FinishedNokhteSessionQueries.COLLABORATOR_UIDS, sortedUIDs);
  });

  test("select", () async {
    await tSetup.supabaseAdmin.from("finished_nokhte_sessions").insert({
      "collaborator_uids": sortedUIDs,
      "content": tSessionContent,
      "session_timestamp": now,
      "session_uid": tSetup.firstUserUID,
      "aliases": ['', ''],
    });
    final res = await user1Queries.select();
    expect(res, isNotEmpty);
  });

  test("selectByCollaborationId", () async {
    final res =
        await user1Queries.selectByCollaborationId(tSetup.secondUserUID);
    expect(
        res.first[FinishedNokhteSessionQueries.COLLABORATOR_UIDS], sortedUIDs);
  });

  test("updateAlias", () async {
    final id = (await user1Queries.select())
        .first[FinishedNokhteSessionQueries.SESSION_UID];
    final res =
        await user1Queries.updateAlias(newAlias: 'test', sessionUID: id);
    expect(
      res.first[FinishedNokhteSessionQueries.ALIASES].contains('test'),
      true,
    );
  });
}
