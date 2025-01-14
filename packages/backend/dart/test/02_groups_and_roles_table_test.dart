// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';

import 'shared/shared.dart';

void main() {
  late GroupsQueries groupQueries;
  late GroupRolesQueries groupRolesQueries;
  late GroupRolesQueries
      unauthorizedGroupRolesQueries; // For adversarial testing
  final tSetup = CommonCollaborativeTestFunctions();

  final testGroupName = 'Test Group';

  setUpAll(() async {
    await tSetup.setUp();
    groupQueries = GroupsQueries(supabase: tSetup.user1Supabase);
    groupRolesQueries = GroupRolesQueries(supabase: tSetup.user1Supabase);
    unauthorizedGroupRolesQueries = GroupRolesQueries(
        supabase: tSetup.user2Supabase); // Second user's queries
  });

  test("should be able to insert & select a group", () async {
    await groupQueries.insert(
      groupName: testGroupName,
    );

    final res = (await groupQueries.select()).first;

    tSetup.groupID = res['id'];

    expect(res, isNotNull);
    expect(res['group_name'], equals(testGroupName));
    expect(res['creator_uid'], equals(tSetup.firstUserUID));
  });

  test("should be able to add themselves as an admin", () async {
    final res = await groupRolesQueries.addUserRole(
      UserRoleParams(
        groupID: tSetup.groupID,
        userUID: tSetup.firstUserUID,
        role: GroupRole.admin,
      ),
    );

    expect(res, isNotEmpty);
    expect(res.first['user_uid'], equals(tSetup.firstUserUID));
    expect(res.first['role'], equals('admin'));
    expect(res.first['group_id'], equals(tSetup.groupID));
  });
  test("unauthorized user should not be able to add themselves", () async {
    try {
      await unauthorizedGroupRolesQueries.addUserRole(
        UserRoleParams(
          groupID: tSetup.groupID,
          userUID: tSetup.secondUserUID,
          role: GroupRole.collaborator,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("should be able to add a new group collaborator", () async {
    final res = await groupRolesQueries.addUserRole(
      UserRoleParams(
        groupID: tSetup.groupID,
        userUID: tSetup.secondUserUID,
        role: GroupRole.collaborator,
      ),
    );

    expect(res, isNotEmpty);
    expect(res.first['user_uid'], equals(tSetup.secondUserUID));
    expect(res.first['role'], equals('collaborator'));
    expect(res.first['group_id'], equals(tSetup.groupID));
  });

  test("collaborator should not be able to promote themselves to admin",
      () async {
    try {
      await groupRolesQueries.updateUserRole(
        UserRoleParams(
          groupID: tSetup.groupID,
          userUID: tSetup.firstUserUID,
          role: GroupRole.admin,
        ),
      );
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });

  test("should be able to promote them to an admin", () async {
    final res = await groupRolesQueries.updateUserRole(
      UserRoleParams(
        groupID: tSetup.groupID,
        userUID: tSetup.secondUserUID,
        role: GroupRole.admin,
      ),
    );

    expect(res, isNotEmpty);
    expect(res.first['user_uid'], equals(tSetup.secondUserUID));
    expect(res.first['role'], equals('admin'));
    expect(res.first['group_id'], equals(tSetup.groupID));
  });

  test("should be able to remove an existing group collaborator", () async {
    final groupID = (await groupQueries.select()).first['id'];
    final res = await groupRolesQueries.removeUserRole(
      UserRoleParams(
        groupID: groupID,
        userUID: tSetup.secondUserUID,
        role: GroupRole.collaborator,
      ),
    );

    expect(res, isNotEmpty);
    expect(res.first['user_uid'], equals(tSetup.secondUserUID));
    expect(res.first['role'], equals('admin'));
    expect(res.first['group_id'], equals(groupID));
  });

  test("should be able to delete a group", () async {
    final res = (await groupQueries.select());
    await groupQueries.delete(res.first['id']);

    final res2 = (await groupQueries.select());

    expect(res2.isEmpty, true);
  });
}
