import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserInformationQueries with UserInformationConstants {
  final SupabaseClient supabase;
  String userUID;

  UserInformationQueries({
    required this.supabase,
  }) : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> insertUserInfo({
    required String firstName,
    required String lastName,
  }) async =>
      await supabase.from(TABLE).insert({
        UID: userUID,
        FIRST_NAME: firstName,
        LAST_NAME: lastName,
      }).select();

  Future<List> getUserInfo({
    String queryUID = '',
  }) async =>
      await supabase.from(TABLE).select().eq(
            UID,
            queryUID.isEmpty ? userUID : queryUID,
          );

  Future<String> getFullName() async {
    final res = await getUserInfo();
    if (res.isNotEmpty) {
      return '${res.first[FIRST_NAME]} ${res.first[LAST_NAME]}';
    } else {
      return '';
    }
  }

  Future<List> deleteUserInfo() async =>
      await supabase.from(TABLE).delete().eq(UID, userUID).select();

  Future<List> getCollaboratorRows() async =>
      await supabase.from(TABLE).select().neq(UID, userUID);
}
