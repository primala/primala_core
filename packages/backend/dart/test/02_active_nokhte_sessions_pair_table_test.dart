// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/_real_time_disabled/finished_nokhte_sessions/queries.dart';
import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/st_active_nokhte_sessions.dart';
import 'shared/shared.dart';

void main() {
  late RTActiveNokhteSessionQueries user1RTQueries;
  late RTActiveNokhteSessionQueries user2RTQueries;
  late RTActiveNokhteSessionsStream user1Stream;
  late STActiveNokhteSessionQueries user1STQueries;
  late STActiveNokhteSessionQueries user2STQueries;
  late FinishedNokhteSessionQueries user1FinishedQueries;
  final tSetup = CommonCollaborativeTestFunctions();
  List sortedArr = [];

  setUpAll(() async {
    await tSetup.setUp();
    sortedArr = [tSetup.firstUserUID, tSetup.secondUserUID];
    user1RTQueries =
        RTActiveNokhteSessionQueries(supabase: tSetup.user1Supabase);
    user2RTQueries =
        RTActiveNokhteSessionQueries(supabase: tSetup.user2Supabase);
    user1STQueries =
        STActiveNokhteSessionQueries(supabase: tSetup.user1Supabase);
    user2STQueries =
        STActiveNokhteSessionQueries(supabase: tSetup.user2Supabase);
    user1FinishedQueries =
        FinishedNokhteSessionQueries(supabase: tSetup.user1Supabase);
    user1Stream = RTActiveNokhteSessionsStream(supabase: tSetup.user1Supabase);
    for (var userUID in sortedArr) {
      await tSetup.supabaseAdmin.from("user_metadata").update({
        "is_subscribed": false,
        "has_used_trial": false,
      }).eq("uid", userUID);
    }
  });

  tearDownAll(() async {
    await tSetup.supabaseAdmin
        .from("finished_nokhte_sessions")
        .delete()
        .eq("collaborator_uids", sortedArr);
  });

  test("initiateSession", () async {
    await user1RTQueries.initializeSession();
    final res = await user1STQueries.select();
    expect(res[0]["leader_uid"], tSetup.firstUserUID);
    expect(res[0]["collaborator_uids"], [tSetup.firstUserUID]);
  });

  test("nukeSession", () async {
    await user1RTQueries.nukeSession();
    final res = await user1STQueries.select();
    expect(res, isEmpty);
    await user1STQueries.initializeSession();
  });

  test("joinSession", () async {
    await user2STQueries.joinSession(tSetup.firstUserUID);
    final res = await user2STQueries.select();
    expect(res[0]["collaborator_uids"], sortedArr);
    expect(res[0]["leader_uid"], tSetup.firstUserUID);
  });

  test("select", () async {
    final res = await user1STQueries.select();
    expect(res, isNotEmpty);
  });

  test("getWhoIsOnline", () async {
    final res = (await user1RTQueries.getWhoIsOnline()).mainType;
    expect(res, [true, true]);
  });

  test("getSpeakerSpotlight", () async {
    final res = (await user1RTQueries.getSpeakerSpotlight()).mainType;
    expect(res, null);
  });

  test("getCurrentPhases", () async {
    final res = (await user1RTQueries.getCurrentPhases()).mainType;
    expect(res, [0, 0]);
  });

  test("getCreatedAt", () async {
    final res = (await user1STQueries.getCreatedAt()).mainType;
    final parsed = DateTime.parse(res);
    expect(res, isA<String>());
    expect(parsed, isA<DateTime>());
  });

  test("startTheSession", () async {
    await user1STQueries.startTheSession();
    final res = await user1RTQueries.getHasBegun();
    expect(res.mainType, true);
  });

  test("updateOnlineStatus", () async {
    await user1RTQueries.updateOnlineStatus(false);
    final onlineStatus = (await user1RTQueries.getWhoIsOnline()).mainType;
    expect(onlineStatus[sortedArr.indexOf(tSetup.firstUserUID)], false);
    expect(onlineStatus[sortedArr.indexOf(tSetup.secondUserUID)], true);
    await user2RTQueries.updateOnlineStatus(false);
    final onlineStatus2 = (await user1RTQueries.getWhoIsOnline()).mainType;
    expect(onlineStatus2[sortedArr.indexOf(tSetup.firstUserUID)], false);
    expect(onlineStatus2[sortedArr.indexOf(tSetup.secondUserUID)], false);
  });

  test("addContent", () async {
    await user1STQueries.addContent('test');
    final res = ((await user1STQueries.getContent())).mainType;
    expect(res, ["test"]);
  });

  test("updateSpeakerSpotlight", () async {
    await user1RTQueries.updateSpeakerSpotlight(addUserToSpotlight: true);
    final res1 = await user1RTQueries.getSpeakerSpotlight();
    expect(res1.mainType, isNotNull);
    await user1RTQueries.updateSpeakerSpotlight(addUserToSpotlight: false);
    final res2 = await user1RTQueries.getSpeakerSpotlight();
    expect(res2.mainType, isNull);
  });

  test("updateCurrentPhases", () async {
    await user1RTQueries.updateCurrentPhases(1);
    final currentPhases = (await user1RTQueries.getCurrentPhases()).mainType;
    expect(currentPhases[sortedArr.indexOf(tSetup.firstUserUID)], 1);
    expect(currentPhases[sortedArr.indexOf(tSetup.secondUserUID)], 0);
    await user2RTQueries.updateCurrentPhases(1);
    final currentPhases2 = (await user1RTQueries.getCurrentPhases()).mainType;
    expect(currentPhases2[sortedArr.indexOf(tSetup.firstUserUID)], 1);
    expect(currentPhases2[sortedArr.indexOf(tSetup.secondUserUID)], 1);
  });

  test("listenToPresenceMetadata", () async {
    final stream = user1Stream.listenToPresenceMetadata();
    expect(
      stream,
      emits(
        NokhteSessionMetadata(
          secondarySpotlightIsEmpty: true,
          speakerUID: null,
          userCanSpeak: true,
          speakingTimerStart: DateTime.fromMillisecondsSinceEpoch(0),
          userIsInSecondarySpeakingSpotlight: false,
          userIsSpeaking: false,
          phases: [1, 1],
          everyoneIsOnline: false,
          sessionHasBegun: true,
        ),
      ),
    );
  });

  test("completeSession", () async {
    final sessionTimestamp = (await user1STQueries.getCreatedAt()).mainType;
    await user1STQueries.completeTheSession();
    final res = await user1FinishedQueries.select();
    expect(res.first["content"], ["test"]);
    expect(
      res.first["collaborator_uids"],
      sortedArr..sort(),
    );
    expect(res.first["session_timestamp"], sessionTimestamp);
    expect(res.first["aliases"], ["", ""]);
  });
}
