// ignore_for_file: constant_identifier_names

import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:nokhte_backend/tables/session_queues.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupInformationQueries {
  static const TABLE = 'group_information';
  static const UID = 'uid';
  static const GROUP_MEMBERS = 'group_members';
  static const GROUP_NAME = 'group_name';
  static const GROUP_HANDLE = 'group_handle';
  static const WITH_SESSIONS =
      '*, ${FinishedSessionsQueries.TABLE}(*), ${SessionQueuesQueries.TABLE}(*)';

  final SupabaseClient supabase;
  final String userUID;

  GroupInformationQueries({
    required this.supabase,
  }) : userUID = supabase.auth.currentUser?.id ?? '';

  Future<List> insert({
    required String groupName,
    required String groupHandle,
  }) async =>
      await supabase.from(TABLE).insert({
        GROUP_NAME: groupName,
        GROUP_HANDLE: groupHandle,
        GROUP_MEMBERS: [userUID],
      }).select();

  Future<List> select() async =>
      await supabase.from(TABLE).select(WITH_SESSIONS);

  Future<List> delete({
    required String uid,
  }) async =>
      await supabase.from(TABLE).delete().eq(UID, uid).select();

  Future<List> updateGroupMembers({
    required String groupId,
    required List<String> members,
    required bool isAdding,
  }) async {
    final currentGroup =
        await supabase.from(TABLE).select().eq(UID, groupId).single();

    List currentMembers = currentGroup[GROUP_MEMBERS] ?? [];

    if (isAdding) {
      for (var member in members) {
        if (!currentMembers.contains(member)) {
          currentMembers.add(member);
        }
      }
    } else {
      currentMembers.removeWhere((member) => members.contains(member));
    }

    return await supabase
        .from(TABLE)
        .update({GROUP_MEMBERS: currentMembers})
        .eq(UID, groupId)
        .select();
  }
}
