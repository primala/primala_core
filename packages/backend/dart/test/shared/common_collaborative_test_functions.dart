import 'package:nokhte_backend/constants/constants.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonCollaborativeTestFunctions {
  late SupabaseClient user1Supabase;
  late SupabaseClient user2Supabase;
  late SupabaseClient user3Supabase;
  late SupabaseClient user4Supabase;
  late SupabaseClient supabaseAdmin;
  late GroupsQueries groupQueries;
  late GroupRequestsQueries u1GroupRequestsQueries;
  late GroupRequestsQueries u2GroupRequestsQueries;
  late UsersQueries usersQueries;
  late String firstUserUID;
  late String secondUserUID;
  late String thirdUserUID;
  late String fourthUserUID;
  late int groupId;

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
    usersQueries = UsersQueries(supabase: user1Supabase);
    u1GroupRequestsQueries = GroupRequestsQueries(supabase: user1Supabase);
    u2GroupRequestsQueries = GroupRequestsQueries(supabase: user2Supabase);

    final userIdResults = await UserSetupConstants.getUIDs();
    firstUserUID = userIdResults.first;
    secondUserUID = userIdResults[1];
    thirdUserUID = userIdResults[2];
    fourthUserUID = userIdResults[3];

    if (createGroup) {
      groupId = (await groupQueries.createGroup(
        CreateGroupParams(
          groupName: 'Test Group',
          profileGradient: ProfileGradient.lagoon,
        ),
      ));
      await usersQueries.updateActiveGroup(groupId);

      final requestId = (await u1GroupRequestsQueries.sendRequests([
        SendRequestParams(
          recipientEmail: '',
          recipientFullName: 'Test User Three',
          recipientProfileGradient: ProfileGradient.amethyst,
          groupId: groupId,
          recipientUid: secondUserUID,
          role: GroupRole.collaborator,
        ),
      ]))
          .first['id'];

      await u2GroupRequestsQueries.handleRequest(
        HandleRequestParams(
          requestId: requestId,
          accept: true,
        ),
      );
    }
  }

  teardown() async {
    await groupQueries.delete(groupId);
  }
}
