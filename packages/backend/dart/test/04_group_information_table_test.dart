// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'shared/shared.dart';

void main() {
  late GroupInformationQueries groupQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  final testGroupName = 'Test Group';
  final testGroupHandle = '@testgroup';
  late List<String> testGroupMembers;

  setUpAll(() async {
    await tSetup.setUp();
    groupQueries = GroupInformationQueries(supabase: tSetup.user1Supabase);
    testGroupMembers = [tSetup.firstUserUID];
  });

  tearDownAll(
    () async => await groupQueries.insert(
      groupName: testGroupName,
      groupHandle: testGroupHandle,
    ),
  );

  test("should be able to insert & select a group", () async {
    await groupQueries.insert(
      groupName: testGroupName,
      groupHandle: testGroupHandle,
    );

    final res = (await groupQueries.select()).first;

    expect(res, isNotNull);
    expect(res['group_name'], equals(testGroupName));
    expect(res['group_handle'], equals(testGroupHandle));
    expect(res['group_members'], equals(testGroupMembers));
  });

  test("should not be able to insert a group with duplicate handle", () async {
    try {
      await groupQueries.insert(
        groupName: 'Another Test Group',
        groupHandle: testGroupHandle,
      );
      fail('Should have thrown an exception');
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });

  test("should be able to add a new group member", () async {
    final testGroupId =
        (await groupQueries.select()).first[GroupInformationQueries.UID];
    final updateResult = await groupQueries.updateGroupMembers(
      groupId: testGroupId,
      members: [tSetup.secondUserUID],
      isAdding: true,
    );

    expect(updateResult.first['group_members'],
        containsAll([tSetup.firstUserUID, tSetup.secondUserUID]));
  });

  test("should be able to remove an existing group member", () async {
    final testGroupId =
        (await groupQueries.select()).first[GroupInformationQueries.UID];
    // First, add the second user
    await groupQueries.updateGroupMembers(
      groupId: testGroupId,
      members: [tSetup.secondUserUID],
      isAdding: true,
    );

    // Then remove the second user
    final updateResult = await groupQueries.updateGroupMembers(
      groupId: testGroupId,
      members: [tSetup.secondUserUID],
      isAdding: false,
    );

    expect(updateResult.first['group_members'], equals([tSetup.firstUserUID]));
  });

  test("should be able to delete a group", () async {
    final res = (await groupQueries.select());
    await groupQueries.delete(uid: res.first['uid']);

    final res2 = (await groupQueries.select());

    expect(res2.isEmpty, true);
  });
}
