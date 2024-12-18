// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/session_queues/queries.dart';
import 'package:nokhte_backend/tables/group_information/group_information.dart';

import 'shared/shared.dart';

void main() {
  late SessionQueuesQueries user1Queries;
  late GroupInformationQueries groupQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  final tQueueContent = ["test1", 'test2', 'test3'];
  final tQueueTitle = "Test Queue";
  late String testGroupId;
  late String insertedQueueUID;

  setUpAll(() async {
    await tSetup.setUp();

    groupQueries = GroupInformationQueries(supabase: tSetup.user1Supabase);
    user1Queries = SessionQueuesQueries(supabase: tSetup.user1Supabase);

    testGroupId =
        (await groupQueries.select()).first[GroupInformationQueries.UID];
  });

  tearDownAll(() async {
    await tSetup.supabaseAdmin
        .from(SessionQueuesQueries.TABLE)
        .delete()
        .eq(SessionQueuesQueries.GROUP_UID, testGroupId);
  });

  test('insert - should successfully insert a new queue', () async {
    final insertResult = await user1Queries.insert(
        groupId: testGroupId,
        queueContent: tQueueContent,
        queueTitle: tQueueTitle);

    expect(insertResult, isNotEmpty);
    expect(insertResult.first[SessionQueuesQueries.TITLE], tQueueTitle);
    expect(insertResult.first[SessionQueuesQueries.CONTENT], tQueueContent);
    expect(insertResult.first[SessionQueuesQueries.GROUP_UID], testGroupId);

    insertedQueueUID = insertResult.first[SessionQueuesQueries.UID];
  });

  test('select - should retrieve queues by group ID', () async {
    await user1Queries.insert(
        groupId: testGroupId,
        queueContent: tQueueContent,
        queueTitle: tQueueTitle);

    final groupQueues = await user1Queries.select(groupId: testGroupId);

    expect(groupQueues, isNotEmpty);
    expect(
        groupQueues.any(
            (queue) => queue[SessionQueuesQueries.GROUP_UID] == testGroupId),
        isTrue);
  });

  test('select - should retrieve a specific queue by UID', () async {
    final specificQueue = await user1Queries.select(uid: insertedQueueUID);

    expect(specificQueue, isNotEmpty);
    expect(specificQueue.first[SessionQueuesQueries.UID], insertedQueueUID);
  });

  test('delete - should successfully delete a queue', () async {
    final insertResult = await user1Queries.insert(
        groupId: testGroupId,
        queueContent: tQueueContent,
        queueTitle: tQueueTitle);
    final queueToDeleteUID = insertResult.first[SessionQueuesQueries.UID];

    final deleteResult = await user1Queries.delete(uid: queueToDeleteUID);

    expect(deleteResult, isNotEmpty);
    expect(deleteResult.first[SessionQueuesQueries.UID], queueToDeleteUID);

    final remainingQueues = await user1Queries.select(uid: queueToDeleteUID);
    expect(remainingQueues, isEmpty);
  });

  test('select - throws assertion error when both uid and groupId are empty',
      () async {
    expect(() async => await user1Queries.select(),
        throwsA(isA<AssertionError>()));
  });

  test('select - throws assertion error when both uid and groupId are provided',
      () async {
    expect(
        () async =>
            await user1Queries.select(uid: 'someUID', groupId: 'someGroupID'),
        throwsA(isA<AssertionError>()));
  });
}
