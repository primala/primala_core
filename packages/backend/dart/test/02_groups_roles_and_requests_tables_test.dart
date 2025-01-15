// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_requests/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/users.dart';

import 'shared/shared.dart';

void main() {
  late GroupsQueries u1GroupQueries;
  late GroupsQueries u2GroupQueries;
  late GroupRolesQueries u1GroupRolesQueries;
  late GroupRequestsQueries u1GroupRequestsQueries;
  late GroupRequestsQueries u2GroupRequestsQueries;
  late GroupRolesQueries u2GroupRolesQueries; // For adversarial testing
  late UsersQueries u1UsersQueries;
  late UsersQueries u2UsersQueries;
  final tSetup = CommonCollaborativeTestFunctions();

  final testGroupName = 'Test Group';

  int requestId = 0;

  setUpAll(() async {
    await tSetup.setUp();
    u1GroupQueries = GroupsQueries(supabase: tSetup.user1Supabase);
    u2GroupQueries = GroupsQueries(supabase: tSetup.user2Supabase);
    u1GroupRolesQueries = GroupRolesQueries(supabase: tSetup.user1Supabase);
    u1GroupRequestsQueries =
        GroupRequestsQueries(supabase: tSetup.user1Supabase);
    u2GroupRequestsQueries =
        GroupRequestsQueries(supabase: tSetup.user2Supabase);
    u2GroupRolesQueries = GroupRolesQueries(
        supabase: tSetup.user2Supabase); // Second user's queries
    u2UsersQueries = UsersQueries(supabase: tSetup.user2Supabase);
    u1UsersQueries = UsersQueries(supabase: tSetup.user1Supabase);
  });

  test("user one should be able to create a group and get added as an admin",
      () async {
    await u1GroupQueries.createGroup(
      groupName: testGroupName,
    );

    final genRes = (await u1GroupQueries.select()).first;

    tSetup.groupId = genRes['id'];
    final rolesRes = (await u1GroupRolesQueries.select(
      groupId: tSetup.groupId,
    ))
        .first;

    expect(genRes['group_name'], equals(testGroupName));
    expect(rolesRes["user_uid"], equals(tSetup.firstUserUID));

    expect(rolesRes["role"], equals("admin"));
    expect(rolesRes["group_id"], equals(tSetup.groupId));
  });

  test("user two should not be able to send them a request from group one",
      () async {
    try {
      await u2GroupRequestsQueries.sendRequest(
        SendRequestParams(
          groupId: tSetup.groupId,
          recipientUid: tSetup.firstUserUID,
          role: GroupRole.admin,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test(
      "user 2 should not be able to delete the recently created group as an outsider",
      () async {
    try {
      await u2GroupQueries.delete(tSetup.groupId);
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("user one should not be able to forcefully add user two to their group",
      () async {
    requestId = (await u1GroupRequestsQueries.sendRequest(
      SendRequestParams(
        groupId: tSetup.groupId,
        recipientUid: tSetup.firstUserUID,
        role: GroupRole.collaborator,
      ),
    ))
        .first['id'];

    await u1GroupRequestsQueries.handleRequest(
      HandleRequestParams(
        requestId: requestId,
        accept: true,
      ),
    );

    final res =
        (await u2GroupRolesQueries.select(groupId: tSetup.groupId)).first;

    expect(res, isEmpty);
  });

  test("user 2 should be able to accept the request on their own", () async {
    await u2GroupRequestsQueries.handleRequest(
      HandleRequestParams(
        requestId: requestId,
        accept: true,
      ),
    );

    final res = (await u2GroupRolesQueries.select(
      groupId: tSetup.groupId,
      userUid: tSetup.secondUserUID,
    ))
        .first;

    expect(res, isNotEmpty);
    expect(res.first['user_uid'], equals(tSetup.secondUserUID));
    expect(res.first['role'], equals('collaborator'));
    expect(res.first['group_id'], equals(tSetup.groupId));
  });

  test('user 2 should be able to read user 1 information', () async {
    final res = (await u2UsersQueries.getUserInfo(
      queryUID: tSetup.firstUserUID,
    ))
        .first;

    expect(res, isNotEmpty);
    expect(res['uid'], equals(tSetup.firstUserUID));
  });

  test('user 1 should be able to read user 2 information', () async {
    final res = (await u1UsersQueries.getUserInfo(
      queryUID: tSetup.secondUserUID,
    ))
        .first;

    expect(res, isNotEmpty);
    expect(res['uid'], equals(tSetup.secondUserUID));
  });

  test(
      "user 2 should not be able to delete the recently created group as a collaborator",
      () async {
    try {
      await u2GroupQueries.delete(tSetup.groupId);
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("user 2 should not be able to send requests", () async {
    try {
      await u2GroupRequestsQueries.sendRequest(
        SendRequestParams(
          groupId: tSetup.groupId,
          recipientUid: tSetup.thirdUserUID,
          role: GroupRole.collaborator,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("user 2 should not be able to promote themselves to an admin", () async {
    try {
      await u2GroupRolesQueries.updateUserRole(
        UserRoleParams(
          groupId: tSetup.groupId,
          userUid: tSetup.secondUserUID,
          role: GroupRole.admin,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("user 1 should be able to promote user 2 to an admin", () async {
    await u1GroupRolesQueries.updateUserRole(
      UserRoleParams(
        groupId: tSetup.groupId,
        userUid: tSetup.secondUserUID,
        role: GroupRole.admin,
      ),
    );

    final res = (await u1GroupRolesQueries.select(
      groupId: tSetup.groupId,
      userUid: tSetup.secondUserUID,
    ))
        .first;

    expect(res.first['user_uid'], equals(tSetup.secondUserUID));
    expect(res.first['role'], equals('admin'));
    expect(res.first['group_id'], equals(tSetup.groupId));
  });

  test("user 2 should be able to remove user 1", () async {
    await u2GroupRolesQueries.removeUserRole(
      UserRoleParams(
        groupId: tSetup.groupId,
        userUid: tSetup.firstUserUID,
        role: GroupRole.admin,
      ),
    );

    final res = (await u2GroupRolesQueries.select(
      groupId: tSetup.groupId,
      userUid: tSetup.secondUserUID,
    ))
        .first;

    expect(res, isEmpty);
  });

  test(
      "user 2 should not be able to remove themselves since they are the only admin left",
      () async {
    try {
      await u2GroupRolesQueries.updateUserRole(
        UserRoleParams(
          groupId: tSetup.groupId,
          userUid: tSetup.secondUserUID,
          role: GroupRole.collaborator,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test('user 2 should be able to set group as their active group', () async {
    await u2UsersQueries.updateActiveGroup(tSetup.groupId);

    final res = (await u2UsersQueries.getUserInfo()).first;

    expect(res['active_group'], equals(tSetup.groupId));
  });

  test("should be able to delete a group", () async {
    // final res = (await u1GroupQueries.select());
    await u2GroupQueries.delete(tSetup.groupId);

    final res2 = (await u2GroupQueries.select());
    final userResponse = (await u2UsersQueries.getUserInfo()).first;

    expect(res2.isEmpty, true);
    expect(userResponse['active_group'], equals(null));
  });
}
