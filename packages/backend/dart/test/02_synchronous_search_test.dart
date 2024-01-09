// ignore_for_file: file_names
import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/edge_functions/edge_functions.dart';
import 'package:nokhte_backend/tables/existing_collaborations.dart';
import 'shared/shared.dart';

void main() {
  late ExistingCollaborationsStream user1Streams;
  late ExistingCollaborationsQueries user1Queries;
  late InitiateCollaboratorSearch user1StartEdgeFunctions;
  late EndCollaboratorSearch user1EndEdgeFunctions;
  late InitiateCollaboratorSearch user2EdgeFunctions;
  final tSetup = CommonCollaborativeTestFunctions();

  setUpAll(() async {
    await tSetup.setUp(shouldMakeCollaboration: false);
    user1Queries =
        ExistingCollaborationsQueries(supabase: tSetup.user1Supabase);
    user1StartEdgeFunctions =
        InitiateCollaboratorSearch(supabase: tSetup.user1Supabase);
    user1EndEdgeFunctions =
        EndCollaboratorSearch(supabase: tSetup.user1Supabase);
    user2EdgeFunctions =
        InitiateCollaboratorSearch(supabase: tSetup.user2Supabase);
    user1Streams = ExistingCollaborationsStream(supabase: tSetup.user1Supabase);
  });

  tearDownAll(() async {
    await tSetup.tearDownAll();
  });

  test("user should be able to enter the pool", () async {
    await user1StartEdgeFunctions.invoke(tSetup.secondUserUID);
    final firstPoolRes =
        await tSetup.supabaseAdmin.from('p2p_collaborator_pool').select();

    expect(firstPoolRes.length, 1);
  });

  test("user should be able to leave the pool", () async {
    await user1EndEdgeFunctions.invoke();

    final secondPoolRes =
        await tSetup.supabaseAdmin.from('p2p_collaborator_pool').select();

    expect(secondPoolRes.length, 0);
  });

  test("user should be able to make a collaboration", () async {
    await user1StartEdgeFunctions.invoke(tSetup.secondUserUID);
    await user2EdgeFunctions.invoke(tSetup.firstUserUID);
    final user1Stream = user1Streams.getCollaboratorSearchAndEntryStatus();
    expect(
        user1Stream,
        emits(CollaboratorSearchAndEntryStatus(
            hasEntered: false, hasFoundTheirCollaborator: true)));
  });
  test("should update the stream accordingly if they make update query",
      () async {
    await user1Queries.updateUserHasEnteredStatus(newEntryStatus: true);
    final user1Stream = user1Streams.getCollaboratorSearchAndEntryStatus();
    expect(
        user1Stream,
        emits(CollaboratorSearchAndEntryStatus(
            hasEntered: true, hasFoundTheirCollaborator: true)));
  });
}
