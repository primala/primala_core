import 'dart:async';

import 'package:nokhte_backend/constants/general/user_data_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client_constants.dart';

class UserSetupConstants {
  static Future<List<String>> getUIDs() async {
    final supabase = SupabaseClientConfigConstants.supabase;
    final List<String> userUIDs = [];
    try {
      for (var i = 0; i < 4; i++) {
        final number = '987654321${i + 1}';
        await supabase.auth.signUp(
          phone: number,
          password: UserDataConstants.universalPassword,
        );

        userUIDs.add(supabase.auth.currentUser?.id ?? '');
        await supabase.auth.signOut();
      }
    } catch (e) {
      for (var i = 0; i < 4; i++) {
        final number = '987654321${i + 1}';
        await supabase.auth.signInWithPassword(
          phone: number,
          password: UserDataConstants.universalPassword,
        );

        userUIDs.add(supabase.auth.currentUser?.id ?? '');
        await supabase.auth.signOut();
      }
    }
    return userUIDs;
  }

  static Future<void> wipeUsernamesTable({
    required SupabaseClient supabaseAdmin,
  }) async {
    final userUIDs = await getUIDs();
    for (var userUID in userUIDs) {
      await supabaseAdmin.from('users').delete().eq(
            'uid',
            userUID,
          );
    }
  }

  static Future<void> setUpUserNamesTableForSubsequentTests(
      {required SupabaseClient supabase}) async {
    final userUIDs = await getUIDs();
    for (var i = 0; i < userUIDs.length; i++) {
      await supabase.from('users').insert(
        {
          "uid": userUIDs[i],
          "email": 'test${i + 1}@test.com',
          "full_name":
              '${UserDataConstants.usersData[i]['firstName']} ${UserDataConstants.usersData[i]['lastName']}',
        },
      );
    }
  }
}
