// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nokhte_backend/constants/constants.dart';

/// @dev: run this one first as all subsequent tests are dependent on the
/// @ code that is run the `teardownAll` block

void main() {
  late SupabaseClient supabaseAdmin;
  late SupabaseClient supabase;
  late String? firstUserUID;
  late UserInformationQueries user1UserInfoQueries;
  late UserInformationQueries adminUserInfoQueries;

  setUpAll(() async {
    supabase = SupabaseClientConfigConstants.supabase;
    supabaseAdmin = SupabaseClientConfigConstants.supabaseAdmin;
    await UserSetupConstants.wipeUsernamesTable(supabaseAdmin: supabaseAdmin);
    final userIdResults = await UserSetupConstants.getUIDs();
    firstUserUID = userIdResults.first;
    await SignIn.user1(supabase: supabase);
    user1UserInfoQueries = UserInformationQueries(supabase: supabase);
    adminUserInfoQueries = UserInformationQueries(supabase: supabaseAdmin);
    adminUserInfoQueries.userUID = firstUserUID ?? '';
  });

  tearDownAll(() async {
    await adminUserInfoQueries.deleteUserInfo();
    await UserSetupConstants.setUpUserNamesTableForSubsequentTests(
      supabase: supabaseAdmin,
    );
  });

  test(
      "✅ should be able to CREATE & READ a row in the table if their uid isn't present already",
      () async {
    final userNamesRes = await user1UserInfoQueries.insertUserInfo(
      firstName: UserDataConstants.user1FirstName,
      lastName: UserDataConstants.user1LastName,
    );
    expect(userNamesRes.first['first_name'], UserDataConstants.user1FirstName);
    expect(userNamesRes.first["last_name"], UserDataConstants.user1LastName);
    expect(userNamesRes.first["uid"], firstUserUID);
  });

  test("❌ shouldn't be able to insert another row if they already have one",
      () async {
    try {
      await user1UserInfoQueries.insertUserInfo(
        firstName: UserDataConstants.user1FirstName,
        lastName: UserDataConstants.user1LastName,
      );
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });
  test("❌ SHOULDN'T be able to enter a UID that isn't theirs", () async {
    try {
      await user1UserInfoQueries.insertUserInfo(
        firstName: UserDataConstants.user1FirstName,
        lastName: UserDataConstants.user1LastName,
      );
    } catch (e) {
      expect(e, isA<PostgrestException>());
    }
  });
}
