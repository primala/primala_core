import 'package:nokhte_backend/constants/constants.dart';
import 'package:nokhte_backend/tables/group_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonCollaborativeTestFunctions {
  late SupabaseClient user1Supabase;
  late SupabaseClient user2Supabase;
  late SupabaseClient user3Supabase;
  late SupabaseClient user4Supabase;
  late SupabaseClient supabaseAdmin;
  late GroupInformationQueries groupQueries;
  late String firstUserUID;
  late String secondUserUID;
  late String thirdUserUID;
  late String fourthUserUID;
  late String groupUID;

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

    final userIdResults = await UserSetupConstants.getUIDs();
    firstUserUID = userIdResults.first;
    secondUserUID = userIdResults[1];
    thirdUserUID = userIdResults[2];
    fourthUserUID = userIdResults[3];

    if (createGroup) {
      groupUID = (await groupQueries.insert(
        groupName: 'Test Group',
        groupHandle: '@testgroup',
      ))
          .first[GroupInformationQueries.UID];

      await groupQueries.updateGroupMembers(
        groupId: groupUID,
        members: [secondUserUID],
        isAdding: true,
      );
    }
  }

  teardown() async {
    await groupQueries.delete(uid: groupUID);
  }
}
