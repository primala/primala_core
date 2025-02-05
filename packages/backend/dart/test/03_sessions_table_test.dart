// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/types/types.dart';
import 'shared/shared.dart';

void main() {
  late SessionsQueries regularQueries;
  late SessionsQueries regularQueries2;
  late SessionsStreams regularStreams;
  late CommonCollaborativeTestFunctions tSetup;
  int regularSessionID = -1;

  setUpAll(() async {
    tSetup = CommonCollaborativeTestFunctions();
    await tSetup.setUp(createGroup: true);
    regularQueries = SessionsQueries(supabase: tSetup.user1Supabase);
    regularQueries2 = SessionsQueries(supabase: tSetup.user2Supabase);
    regularStreams = SessionsStreams(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    await tSetup.teardown();
  });

  test('initializeSession - initializes active session', () async {
    final res = await regularQueries.initializeSession(InitializeSessionParams(
      collaborators: [
        SessionUserEntity(
          profileGradient: ProfileGradient.amethyst,
          uid: tSetup.firstUserUID,
          fullName: 'User 1',
          sessionUserStatus: SessionUserStatus.offline,
        ),
        SessionUserEntity(
          profileGradient: ProfileGradient.amethyst,
          uid: tSetup.secondUserUID,
          fullName: 'User 2',
          sessionUserStatus: SessionUserStatus.offline,
        )
      ],
      docIds: [],
      groupId: tSetup.groupId,
    ));
    regularSessionID = res['id'];
    expect(res, isNotEmpty);
    expect(res['collaborator_uids'], contains(tSetup.firstUserUID));
    expect(res['status'], 'recruiting');
  });

  group('Regular Session Operations', () {
    test('findCurrentSession - finds active session', () async {
      await regularQueries.findCurrentSession();
      expect(regularQueries.sessionID, regularSessionID);
      expect(regularQueries.userIndex, 0);
    });

    test('updateUserStatus - updates user status', () async {
      final res = await regularQueries.updateUserStatus(
        SessionUserStatus.readyToStart,
      );
      expect(res, isEmpty);

      final metadata = await regularQueries.getCollaboratorStatuses();
      expect(
        metadata.mainType[0],
        regularQueries.mapSessionUserStatusToString(
          SessionUserStatus.readyToStart,
        ),
      );
    });

    test('updateUserStatus - second user can updates user status', () async {
      await regularQueries2.updateUserStatus(SessionUserStatus.hasJoined);

      final res = await regularQueries.select();
      expect(
        res.first['collaborator_statuses'],
        [
          regularQueries.mapSessionUserStatusToString(
            SessionUserStatus.readyToStart,
          ),
          regularQueries.mapSessionUserStatusToString(
            SessionUserStatus.hasJoined,
          ),
        ],
      );
    });

    test('beginSession - transitions to started state', () async {
      final res = await regularQueries.beginSession();
      expect(res, isNotEmpty);

      final status = await regularQueries.getSessionStatus();
      expect(
        status.mainType,
        regularQueries.mapSessionStatusToString(
          SessionStatus.started,
        ),
      );
    });

    test('updateSpeakerSpotlight - manages speaker spotlight', () async {
      // Add user to spotlight
      var res = await regularQueries.updateSpeakerSpotlight(
        addUserToSpotlight: true,
      );
      expect(res, isNotEmpty);

      var spotlight = await regularQueries.getSpeakerSpotlight();
      expect(spotlight.mainType, regularQueries.userUID);

      // Remove user from spotlight
      res = await regularQueries.updateSpeakerSpotlight(
        addUserToSpotlight: false,
      );
      expect(res, isNotEmpty);

      spotlight = await regularQueries.getSpeakerSpotlight();
      expect(spotlight.mainType, isNull);
    });

    test('updateSecondarySpeakerSpotlight - manages secondary speaker',
        () async {
      // First add primary speaker
      await regularQueries.updateSpeakerSpotlight(
        addUserToSpotlight: true,
      );

      // Add secondary speaker
      var res = await regularQueries.updateSecondarySpeakerSpotlight(
        addToSecondarySpotlight: true,
        secondarySpeakerUID: tSetup.secondUserUID,
      );
      expect(res, isNotEmpty);

      // Remove secondary speaker
      res = await regularQueries.updateSecondarySpeakerSpotlight(
        addToSecondarySpotlight: false,
        secondarySpeakerUID: tSetup.secondUserUID,
      );
      expect(res, isNotEmpty);
    });

    test('speaking timer operations', () async {
      // Update timer
      var res = await regularQueries.updateSpeakingTimerStart();
      expect(res, isNotEmpty);

      // Refresh timer
      res = await regularQueries.refreshSpeakingTimerStart();
      expect(res, isNotEmpty);
    });
  });

  group('Regular Streams', () {
    test('listenToPresenceMetadata - streams session metadata', () async {
      final stream = regularStreams.listenToPresenceMetadata();
      final result = await stream.first;

      expect(result.sessionId, regularSessionID);
      expect(result.sessionStatus, SessionStatus.started);
      expect(result.collaborators, hasLength(2));
      expect(result.collaborators.first.uid, tSetup.firstUserUID);
      expect(result.collaborators[1].uid, tSetup.secondUserUID);
    });

    test('cancelGetSessionMetadataStream - stops streaming', () async {
      final result = await regularStreams.cancelGetSessionMetadataStream();
      expect(result, false);
      expect(regularStreams.metadataListeningStatus, false);
    });
  });
}
