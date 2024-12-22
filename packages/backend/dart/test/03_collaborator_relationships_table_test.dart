// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/types/types.dart';
import 'shared/shared.dart';

void main() {
  late CollaboratorRelationshipsQueries user1Queries;
  late CollaboratorRelationshipsQueries user2Queries;
  late CollaboratorRelationshipsStream user1Stream;
  final tSetup = CommonCollaborativeTestFunctions();
  List<Map<String, dynamic>> createdRelationships = [];

  setUpAll(() async {
    await tSetup.setUp();
    user1Queries =
        CollaboratorRelationshipsQueries(supabase: tSetup.user1Supabase);
    user2Queries =
        CollaboratorRelationshipsQueries(supabase: tSetup.user2Supabase);
    user1Stream =
        CollaboratorRelationshipsStream(supabase: tSetup.user1Supabase);
  });

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

  test('stream handles multiple relationships correctly', () async {
    await user1Queries.insert(
      collaboratorTwoUid: tSetup.fourthUserUID,
    );
    final stream = user1Stream.listenToCollaboratorRelationships();

    expect(
      stream,
      emits(
        isA<List<UserInformationEntity>>()
            .having(
              (collaborators) =>
                  collaborators.any((c) => c.uid == tSetup.secondUserUID) &&
                  collaborators.any((c) => c.uid == tSetup.fourthUserUID),
              'contains both collaborators',
              true,
            )
            .having(
              (collaborators) => collaborators.length,
              'has correct number of collaborators',
              2,
            ),
      ),
    );
  });
  test('trackedCollaboratorIds - maintains list of tracked collaborators',
      () async {
    final stream = user1Stream.listenToCollaboratorRelationships();

    await stream.first;

    expect(
      user1Stream.trackedCollaboratorIds,
      contains(tSetup.secondUserUID),
    );
  });

  test('cancelRelationshipsListeningStream - stops listening to updates',
      () async {
    final result = await user1Stream.cancelRelationshipsListeningStream();
    expect(result, false);
    expect(user1Stream.collaboratorRelationshipsListeningStatus, false);
  });

  test('delete - allows either collaborator to delete the relationship',
      () async {
    final newRelationship = await user2Queries.select();

    final res = await user2Queries.delete(uid: newRelationship.first['uid']);

    expect(res, isNotEmpty);
    expect(res.first['uid'], newRelationship.first['uid']);

    final otherRelationship = await user1Queries.select();
    final otherRes =
        await user1Queries.delete(uid: otherRelationship.first['uid']);

    expect(otherRes, isNotEmpty);
    expect(otherRes.first['uid'], otherRelationship.first['uid']);
  });
}
