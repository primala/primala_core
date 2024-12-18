// ignore_for_file: file_names
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'shared/shared.dart';

void main() {
  late CollaboratorRelationshipsQueries user1Queries;
  late CollaboratorRelationshipsQueries user2Queries;
  final tSetup = CommonCollaborativeTestFunctions();
  List<Map<String, dynamic>> createdRelationships = [];

  setUpAll(() async {
    await tSetup.setUp();
    user1Queries =
        CollaboratorRelationshipsQueries(supabase: tSetup.user1Supabase);
    user2Queries =
        CollaboratorRelationshipsQueries(supabase: tSetup.user2Supabase);
  });

  tearDownAll(() async {
    for (var relationship in createdRelationships) {
      await tSetup.supabaseAdmin
          .from('collaborator_relationships')
          .delete()
          .eq('id', relationship['id']);
    }
  });

  group('Queries Tests', () {
    test('insert - creates a new collaborator relationship', () async {
      final res = await user1Queries.insert(
        collaboratorTwoUid: tSetup.secondUserUID,
      );

      expect(res, isNotEmpty);
      expect(res.first['collaborator_one_uid'], tSetup.firstUserUID);
      expect(res.first['collaborator_two_uid'], tSetup.secondUserUID);
      expect(res.first['created_at'], isNotNull);

      createdRelationships.add(res.first);
    });

    test('insert - creates a relationship with different initiator', () async {
      final res = await user2Queries.insert(
        collaboratorTwoUid: tSetup.firstUserUID,
      );

      expect(res, isNotEmpty);
      expect(res.first['collaborator_one_uid'], tSetup.secondUserUID);
      expect(res.first['collaborator_two_uid'], tSetup.firstUserUID);
      expect(res.first['created_at'], isNotNull);

      createdRelationships.add(res.first);
    });

    test('delete - removes a collaborator relationship', () async {
      // Create a new relationship to delete
      final newRelationship = await user1Queries.insert(
        collaboratorTwoUid: tSetup.secondUserUID,
      );

      final res = await user1Queries.delete(id: newRelationship.first['id']);

      expect(res, isNotEmpty);
      expect(res.first['id'], newRelationship.first['id']);
      expect(res.first['collaborator_one_uid'], tSetup.firstUserUID);
      expect(res.first['collaborator_two_uid'], tSetup.secondUserUID);
    });

    test('delete - allows either collaborator to delete the relationship',
        () async {
      final newRelationship = await user1Queries.insert(
        collaboratorTwoUid: tSetup.secondUserUID,
      );
      createdRelationships.add(newRelationship.first);

      final res = await user2Queries.delete(id: newRelationship.first['id']);

      expect(res, isNotEmpty);
      expect(res.first['id'], newRelationship.first['id']);
    });
  });
}
