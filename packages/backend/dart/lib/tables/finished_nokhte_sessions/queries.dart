// ignore_for_file: constant_identifier_names
import 'package:supabase_flutter/supabase_flutter.dart';

class FinishedSessionQueries {
  static const TABLE = 'finished_sessions';
  static const COLLABORATOR_UIDS = 'collaborator_uids';
  static const SESSION_TIMESTAMP = 'session_timestamp';
  static const CONTENT = 'content';
  static const ALIASES = 'aliases';
  static const SESSION_UID = 'session_uid';
  static const PRESET_UID = 'preset_uid';

  final SupabaseClient supabase;
  final String userUID;

  FinishedSessionQueries({required this.supabase})
      : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> select() async =>
      await supabase.from(TABLE).select().order('session_timestamp');

  Future<List> selectOne({
    String unifiedUID = '',
    bool invertToNeq = false,
  }) async {
    if (unifiedUID.isEmpty) {
      return await supabase.from(TABLE).select().limit(1);
    } else {
      if (invertToNeq) {
        return await supabase
            .from(TABLE)
            .select()
            .neq(PRESET_UID, unifiedUID)
            .limit(1);
      } else {
        return await supabase
            .from(TABLE)
            .select()
            .eq(PRESET_UID, unifiedUID)
            .limit(1);
      }
    }
  }

  Future<List> selectByCollaborationId(String collaboratorUID) async {
    final sortedCollaboratorUIDs = [userUID, collaboratorUID]..sort();
    return await supabase
        .from(TABLE)
        .select()
        .eq(COLLABORATOR_UIDS, sortedCollaboratorUIDs)
        .order(SESSION_TIMESTAMP);
  }

  Future<List> updateAlias({
    required String newAlias,
    required String sessionUID,
  }) async {
    final sessionRes =
        await supabase.from(TABLE).select().eq(SESSION_UID, sessionUID);
    final aliases = sessionRes.first[ALIASES];
    final userIndex = sessionRes.first[COLLABORATOR_UIDS].indexOf(userUID);
    aliases[userIndex] = newAlias;
    return await supabase
        .from(TABLE)
        .update({ALIASES: aliases})
        .eq(SESSION_UID, sessionUID)
        .select();
  }
}
