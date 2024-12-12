// ignore_for_file: constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';

class SessionQueuesQueries {
  static const TABLE = 'session_queues';
  static const GROUP_UID = 'group_uid';
  static const CREATED_AT = 'created_at';
  static const CONTENT = 'content';
  static const TITLE = 'title';
  static const UID = 'uid';

  final SupabaseClient supabase;
  final String userUID;

  SessionQueuesQueries({required this.supabase})
      : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> select({
    String groupId = '',
    String uid = '',
  }) async {
    assert(
      (uid.isEmpty && groupId.isNotEmpty) ||
          (uid.isNotEmpty && groupId.isEmpty),
      'Either uid or groupId must be provided but not both',
    );
    if (uid.isEmpty && groupId.isNotEmpty) {
      return await supabase
          .from(TABLE)
          .select()
          .eq(GROUP_UID, groupId)
          .order(CREATED_AT);
    } else {
      return await supabase.from(TABLE).select().eq(UID, uid);
    }
  }

  Future<List> insert({
    required String groupId,
    required List<String> queueContent,
    required String queueTitle,
  }) async {
    return await supabase.from(TABLE).insert({
      TITLE: queueTitle,
      CONTENT: queueContent,
      GROUP_UID: groupId,
    }).select();
  }

  Future<List> delete({
    required String uid,
  }) async =>
      await supabase.from(TABLE).delete().eq(UID, uid).select();
}
