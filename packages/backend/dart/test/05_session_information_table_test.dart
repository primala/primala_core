// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/sessions/utilities/utilities.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'shared/shared.dart';

void main() {
  late DormantSessionsQueries dormantQueries;
  late DormantSessionsStreams dormantStreams;
  late SessionsQueries regularQueries;
  late SessionsQueries regularQueries2;
  late UsersQueries usersQueries;
  late SessionsStreams regularStreams;
  late CommonCollaborativeTestFunctions tSetup;
  String dormantSessionUID = '';
  String regularSessionUID = '';

  setUpAll(() async {
    tSetup = CommonCollaborativeTestFunctions();
    await tSetup.setUp(createGroup: true);
    dormantQueries = DormantSessionsQueries(supabase: tSetup.user1Supabase);
    dormantStreams = DormantSessionsStreams(supabase: tSetup.user1Supabase);
    usersQueries = UsersQueries(supabase: tSetup.user1Supabase);
    regularQueries = SessionsQueries(supabase: tSetup.user1Supabase);
    regularQueries2 = SessionsQueries(supabase: tSetup.user2Supabase);
    regularStreams = SessionsStreams(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    await tSetup.teardown();
  });

  group('Dormant Session Flow', () {
    group('Dormant Queries', () {
      test('initializeDormantSession - creates dormant session', () async {
        final res =
            await dormantQueries.initializeDormantSession(tSetup.groupUID);
        expect(res, isNotEmpty);
        expect(res.first['status'], 'dormant');
        expect(res.first['collaborator_uids'], isEmpty);
        expect(res.first['collaborator_names'], isEmpty);
        expect(res.first['collaborator_statuses'], isEmpty);
        dormantSessionUID = res.first['uid'];
      });

      test('updateSessionTitle - updates dormant session title', () async {
        final params = UpdateSessionTitleParams(
          sessionUID: dormantSessionUID,
          title: 'Test Session',
        );
        final res = await dormantQueries.updateSessionTitle(params);
        expect(res, isNotEmpty);
        expect(res.first['title'], 'Test Session');
        expect(res.first['version'], 1);
      });
    });

    group('Dormant Streams', () {
      test('listenToSessions - streams dormant session updates', () async {
        final stream = dormantStreams.listenToSessions(tSetup.groupUID);
        final result = await stream.first;

        expect(result.dormantSessions, hasLength(1));
        expect(result.dormantSessions.first.uid, dormantSessionUID);
        expect(result.dormantSessions.first.title, 'Test Session');
        expect(result.finishedSessions, isEmpty);
      });

      test('cancelSessionsStream - stops streaming', () async {
        final result = await dormantStreams.cancelSessionsStream();
        expect(result, false);
        expect(dormantStreams.groupSessionsListeningStatus, false);
      });
    });

    test('awakenDormantSession - transitions to recruiting', () async {
      final res = await dormantQueries.awakenDormantSession(dormantSessionUID);
      expect(res, isNotEmpty);
      expect(res.first['status'], 'recruiting');
      expect(res.first['created_at'], isNotNull);

      await regularQueries.cleanUpSessions();
    });
  });

  group('Regular Session Flow', () {
    test('initializeSession - initializes active session', () async {
      final res = await regularQueries.initializeSession(tSetup.groupUID);
      regularSessionUID = res.first['uid'];
      expect(res, isNotEmpty);
      expect(res.first['collaborator_uids'], contains(tSetup.firstUserUID));
      expect(res.first['status'], 'recruiting');
    });

    group('Regular Session Operations', () {
      test('findCurrentSession - finds active session', () async {
        await regularQueries.findCurrentSession();
        expect(regularQueries.sessionUID, regularSessionUID);
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

      test('joinSession - second user can join the session', () async {
        await regularQueries2.joinSession(regularSessionUID);
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

        expect(result.sessionUID, regularSessionUID);
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
  });
}
