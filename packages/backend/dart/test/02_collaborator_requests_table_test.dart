// ignore_for_file: file_names
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'shared/shared.dart';

void main() {
  late CollaboratorRequestsQueries user1Queries;
  late CollaboratorRequestsQueries user2Queries;
  late CollaboratorRelationshipsQueries user2RelationshipsQueries;

  final tSetup = CommonCollaborativeTestFunctions();
  List<Map<String, dynamic>> createdRequests = [];

  setUpAll(() async {
    await tSetup.setUp();
    user1Queries = CollaboratorRequestsQueries(supabase: tSetup.user1Supabase);
    user2RelationshipsQueries =
        CollaboratorRelationshipsQueries(supabase: tSetup.user2Supabase);
    user2Queries = CollaboratorRequestsQueries(supabase: tSetup.user2Supabase);
  });

  tearDownAll(() async {
    // Clean up any remaining requests
    for (var request in createdRequests) {
      await tSetup.supabaseAdmin
          .from('collaborator_requests')
          .delete()
          .eq('uid', request['uid']);
    }
    final newRelationship = await user2RelationshipsQueries.select();

    await user2RelationshipsQueries.delete(uid: newRelationship.first['uid']);
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

    test('updateStatus - rejects a collaboration request', () async {
      await user2Queries.updateStatus(
        senderUID: tSetup.firstUserUID,
        requestUID: createdRequests.first['uid'],
        isAccepted: false,
      );

      final res = await user2RelationshipsQueries.select();

      expect(res, isEmpty);
    });
    test('updateStatus - accepts a collaboration request', () async {
      await user2Queries.updateStatus(
        senderUID: tSetup.firstUserUID,
        requestUID: createdRequests.first['uid'],
        isAccepted: true,
      );

      final res = await user2RelationshipsQueries.select();

      expect(res, isNotEmpty);
    });
  });
}
