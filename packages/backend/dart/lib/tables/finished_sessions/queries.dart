// ignore_for_file: constant_identifier_names
import 'package:supabase_flutter/supabase_flutter.dart';

class FinishedSessionsQueries {
  static const TABLE = 'finished_sessions';
  static const GROUP_UID = 'group_uid';
  static const SESSION_TIMESTAMP = 'session_timestamp';
  static const CONTENT = 'content';
  static const SESSION_UID = 'session_uid';

  final SupabaseClient supabase;
  final String userUID;

  FinishedSessionsQueries({required this.supabase})
      : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> select({
    String groupId = '',
  }) async {
    if (groupId.isNotEmpty) {
      return await supabase
          .from(TABLE)
          .select()
          .eq(GROUP_UID, groupId)
          .order(SESSION_TIMESTAMP);
    }
    return await supabase.from(TABLE).select().order('session_timestamp');
  }

  Future<List> delete(String sessionUID) async =>
      await supabase.from(TABLE).delete().eq(SESSION_UID, sessionUID).select();
}
