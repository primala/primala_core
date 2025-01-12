import 'package:nokhte_backend/constants/constants.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonCollaborativeTestFunctions {
  late SupabaseClient user1Supabase;
  late SupabaseClient user2Supabase;
  late SupabaseClient user3Supabase;
  late SupabaseClient user4Supabase;
  late SupabaseClient supabaseAdmin;
  late GroupsQueries groupQueries;
  late GroupRolesQueries groupRolesQueries;
  late String firstUserUID;
  late String secondUserUID;
  late String thirdUserUID;
  late String fourthUserUID;
  late int groupID;

  CommonCollaborativeTestFunctions() {
    user1Supabase = SupabaseClientConfigConstants.supabase;
    user2Supabase = SupabaseClientConfigConstants.supabase;
    user3Supabase = SupabaseClientConfigConstants.supabase;
    user4Supabase = SupabaseClientConfigConstants.supabase;
    supabaseAdmin = SupabaseClientConfigConstants.supabaseAdmin;
  }

  Future<void> setUp({
    bool createGroup = false,
  }) async {
    await SignIn.user1(supabase: user1Supabase);
    await SignIn.user2(supabase: user2Supabase);
    await SignIn.user3(supabase: user3Supabase);
    await SignIn.user4(supabase: user4Supabase);
    groupQueries = GroupsQueries(supabase: user1Supabase);
    groupRolesQueries = GroupRolesQueries(supabase: user1Supabase);

    final userIdResults = await UserSetupConstants.getUIDs();
    firstUserUID = userIdResults.first;
    secondUserUID = userIdResults[1];
    thirdUserUID = userIdResults[2];
    fourthUserUID = userIdResults[3];

    if (createGroup) {
      groupID = (await groupQueries.insert(
        groupName: 'Test Group',
      ))
          .first[GroupsQueries.ID];

      await groupRolesQueries.addUserRole(
        UserRoleParams(
          groupID: groupID,
          userUID: firstUserUID,
          role: GroupRole.admin,
        ),
      );

      await groupRolesQueries.addUserRole(
        UserRoleParams(
          groupID: groupID,
          userUID: secondUserUID,
          role: GroupRole.collaborator,
        ),
      );
    }
  }

  teardown() async {
    await groupQueries.delete(id: groupID);
  }
}
