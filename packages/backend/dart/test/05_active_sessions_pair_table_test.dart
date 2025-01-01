// // ignore_for_file: file_names
// import 'package:flutter_test/flutter_test.dart';
// import 'package:nokhte_backend/tables/finished_sessions/queries.dart';
// import 'package:nokhte_backend/tables/group_information.dart';
// import 'package:nokhte_backend/tables/session_information.dart';
// import 'package:nokhte_backend/tables/static_active_sessions.dart';
// import 'shared/shared.dart';

// void main() {
//   late RealtimeActiveSessionQueries user1RTQueries;
//   late RealtimeActiveSessionQueries user2RTQueries;
//   late RealtimeActiveSessionStreams user1Stream;
//   late GroupInformationQueries groupQueries;
//   late StaticActiveSessionQueries user1STQueries;
//   late FinishedSessionsQueries user1FinishedQueries;
//   final tSetup = CommonCollaborativeTestFunctions();
//   List sortedArr = [];

//   setUpAll(() async {
//     await tSetup.setUp();
//     sortedArr = [tSetup.firstUserUID, tSetup.secondUserUID];
//     user1RTQueries =
//         RealtimeActiveSessionQueries(supabase: tSetup.user1Supabase);
//     groupQueries = GroupInformationQueries(supabase: tSetup.user1Supabase);
//     user2RTQueries =
//         RealtimeActiveSessionQueries(supabase: tSetup.user2Supabase);
//     user1STQueries = StaticActiveSessionQueries(supabase: tSetup.user1Supabase);
//     user1FinishedQueries =
//         FinishedSessionsQueries(supabase: tSetup.user1Supabase);
//     user1Stream = RealtimeActiveSessionStreams(supabase: tSetup.user1Supabase);
//   });

//   tearDownAll(() async {
//     final res = (await groupQueries.select()).first['uid'];
//     await tSetup.supabaseAdmin
//         .from("finished_sessions")
//         .delete()
//         .eq("group_uid", res);
//   });

//   test("initiateSession", () async {
//     final res = (await groupQueries.insert(
//       groupName: 'Test Group',
//       groupHandle: '@testgroup',
//     ))
//         .first[GroupInformationQueries.UID];

//     final realTimeRes = await user1STQueries.initializeSession(groupUID: res);
//     final staticRes = await user1STQueries.select();
//     expect(staticRes[0]["session_uid"], realTimeRes[0]["session_uid"]);
//     expect(staticRes[0]["leader_uid"], tSetup.firstUserUID);
//     expect(staticRes[0]["collaborator_uids"], [tSetup.firstUserUID]);
//   });

//   test("nukeSession", () async {
//     await user1RTQueries.nukeSession();
//     final res = await user1STQueries.select();
//     expect(res, isEmpty);
//     final groupId =
//         (await groupQueries.select()).first[GroupInformationQueries.UID];
//     await user1STQueries.initializeSession(
//       groupUID: groupId,
//     );
//   });

//   test("select", () async {
//     final res = await user1STQueries.select();
//     expect(res, isNotEmpty);
//   });

//   test("getWhoIsOnline", () async {
//     final res = (await user1RTQueries.getWhoIsOnline()).mainType;
//     expect(res, [true, true]);
//   });

//   test("getSpeakerSpotlight", () async {
//     final res = (await user1RTQueries.getSpeakerSpotlight()).mainType;
//     expect(res, null);
//   });

//   test("getCurrentPhases", () async {
//     final res = (await user1RTQueries.getCurrentPhases()).mainType;
//     expect(res, [0, 0]);
//   });

//   test("getCreatedAt", () async {
//     final res = (await user1STQueries.getCreatedAt()).mainType;
//     final parsed = DateTime.parse(res);
//     expect(res, isA<String>());
//     expect(parsed, isA<DateTime>());
//   });

//   test("beginSession", () async {
//     await user1RTQueries.beginSession();
//     final res = await user1RTQueries.getHasBegun();
//     expect(res.mainType, true);
//   });

//   test("updateOnlineStatus", () async {
//     await user1RTQueries.updateOnlineStatus(false);
//     final onlineStatus = (await user1RTQueries.getWhoIsOnline()).mainType;
//     expect(onlineStatus[sortedArr.indexOf(tSetup.firstUserUID)], false);
//     expect(onlineStatus[sortedArr.indexOf(tSetup.secondUserUID)], true);
//     await user2RTQueries.updateOnlineStatus(false);
//     final onlineStatus2 = (await user1RTQueries.getWhoIsOnline()).mainType;
//     expect(onlineStatus2[sortedArr.indexOf(tSetup.firstUserUID)], false);
//     expect(onlineStatus2[sortedArr.indexOf(tSetup.secondUserUID)], false);
//   });

//   test("addContent", () async {
//     await user1RTQueries.addContent('test');
//     final res = ((await user1RTQueries.getContent())).mainType;
//     expect(res, ["test"]);
//   });

//   test("updateSpeakerSpotlight", () async {
//     await user1RTQueries.updateSpeakerSpotlight(addUserToSpotlight: true);
//     final res1 = await user1RTQueries.getSpeakerSpotlight();
//     expect(res1.mainType, isNotNull);
//     await user1RTQueries.updateSpeakerSpotlight(addUserToSpotlight: false);
//     final res2 = await user1RTQueries.getSpeakerSpotlight();
//     expect(res2.mainType, isNull);
//   });

//   test("updateGroupUID", () async {
//     final res =
//         (await groupQueries.select()).first[GroupInformationQueries.UID];
//     await user1STQueries.updateGroupUID(res);
//     final res1 = await user1STQueries.getGroupUID();
//     expect(res1.mainType, isNotNull);
//   });

//   test("updateCurrentPhases", () async {
//     await user1RTQueries.updateCurrentPhases(1);
//     final currentPhases = (await user1RTQueries.getCurrentPhases()).mainType;
//     expect(currentPhases[sortedArr.indexOf(tSetup.firstUserUID)], 1);
//     expect(currentPhases[sortedArr.indexOf(tSetup.secondUserUID)], 0);
//     await user2RTQueries.updateCurrentPhases(1);
//     final currentPhases2 = (await user1RTQueries.getCurrentPhases()).mainType;
//     expect(currentPhases2[sortedArr.indexOf(tSetup.firstUserUID)], 1);
//     expect(currentPhases2[sortedArr.indexOf(tSetup.secondUserUID)], 1);
//   });

//   test("listenToPresenceMetadata", () async {
//     final stream = user1Stream.listenToPresenceMetadata();
//     expect(
//       stream,
//       emits(
//         SessionMetadata(
//           secondarySpotlightIsEmpty: true,
//           content: ["test"],
//           speakerUID: null,
//           userCanSpeak: true,
//           speakingTimerStart: DateTime.fromMillisecondsSinceEpoch(0),
//           userIsInSecondarySpeakingSpotlight: false,
//           userIsSpeaking: false,
//           phases: [1, 1],
//           everyoneIsOnline: false,
//           sessionHasBegun: true,
//         ),
//       ),
//     );
//   });

//   test("completeSession", () async {
//     final sessionTimestamp = (await user1STQueries.getCreatedAt()).mainType;
//     await user1STQueries.completeTheSession();
//     final groupId = (await groupQueries.select()).first['uid'];
//     final res = await user1FinishedQueries.select(groupId: groupId);
//     expect(res.first["content"], ["test"]);
//     expect(res.first["group_uid"], groupId);
//     expect(res.first["session_timestamp"], sessionTimestamp);
//   });
// }
