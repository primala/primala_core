// ignore_for_file: file_names
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'shared/shared.dart';

void main() {
  late CollaboratorRequestsQueries user1Queries;
  late CollaboratorRequestsQueries user2Queries;
  late CollaboratorRequestsStream user1Stream;
  final tSetup = CommonCollaborativeTestFunctions();
  List<Map<String, dynamic>> createdRequests = [];

  setUpAll(() async {
    await tSetup.setUp();
    user1Queries = CollaboratorRequestsQueries(supabase: tSetup.user1Supabase);
    user2Queries = CollaboratorRequestsQueries(supabase: tSetup.user2Supabase);
    user1Stream = CollaboratorRequestsStream(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    // Clean up any remaining requests
    for (var request in createdRequests) {
      await tSetup.supabaseAdmin
          .from('collaborator_requests')
          .delete()
          .eq('uid', request['uid']);
    }
  });

  group('Queries Tests', () {
    test('insert - creates a new collaboration request', () async {
      final res = await user1Queries.insert(
        recipientUID: tSetup.secondUserUID,
        senderName: 'Test User 1',
      );

      expect(res, isNotEmpty);
      expect(res.first['sender_uid'], tSetup.firstUserUID);
      expect(res.first['recipient_uid'], tSetup.secondUserUID);
      expect(res.first['status'], 'pending');
      expect(res.first['sender_name'], 'Test User 1');

      createdRequests.add(res.first);
    });

    test('updateStatus - accepts a collaboration request', () async {
      final res = await user2Queries.updateStatus(
        uid: createdRequests.first['uid'],
        isAccepted: true,
      );

      expect(res, isNotEmpty);
      expect(res.first['status'], 'accepted');
    });

    test('updateStatus - rejects a collaboration request', () async {
      // Create a new request to reject
      final newRequest = await user1Queries.insert(
        recipientUID: tSetup.secondUserUID,
        senderName: 'Test User 1',
      );
      createdRequests.add(newRequest.first);

      final res = await user2Queries.updateStatus(
        uid: newRequest.first['uid'],
        isAccepted: false,
      );

      expect(res, isNotEmpty);
      expect(res.first['status'], 'rejected');
    });

    test('delete - removes a collaboration request', () async {
      // Create a new request to delete
      final newRequest = await user1Queries.insert(
        recipientUID: tSetup.secondUserUID,
        senderName: 'Test User 1',
      );

      final res = await user1Queries.delete(uid: newRequest.first['uid']);

      expect(res, isNotEmpty);
      expect(res.first['uid'], newRequest.first['uid']);
    });
  });

  group('Streams Tests', () {
    test('listenToCollaboratorRequests - receives updates for new requests',
        () async {
      final stream = user1Stream.listenToCollaboratorRequests();

      // Create a new request that should be picked up by the stream
      final newRequest = await user2Queries.insert(
        recipientUID: tSetup.firstUserUID,
        senderName: 'Test User 2',
      );
      createdRequests.add(newRequest.first);

      expect(
        stream,
        emits(
          isA<List<CollaboratorRequests>>().having(
              (requests) => requests.any(
                    (request) =>
                        request.senderUID == tSetup.secondUserUID &&
                        request.senderName == 'Test User 2',
                  ),
              'contains new request',
              true),
        ),
      );
    });

    test('cancelRequestsListeningStream - stops listening to updates',
        () async {
      final result = await user1Stream.cancelRequestsListeningStream();
      expect(result, false);
      expect(user1Stream.collaboratorRequestsListeningStatus, false);
    });
  });
}
