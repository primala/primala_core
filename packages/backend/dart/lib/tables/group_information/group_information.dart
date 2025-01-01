// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupInformationQueries {
  static const TABLE = 'group_information';
  static const UID = 'uid';
  static const GROUP_MEMBERS = 'group_members';
  static const GROUP_NAME = 'group_name';
  static const GROUP_HANDLE = 'group_handle';
  static const WITH_SESSIONS = '';

  final SupabaseClient supabase;
  final String userUID;
  final UserInformationQueries userInfoQueries;

  GroupInformationQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInfoQueries = UserInformationQueries(supabase: supabase);

  Future<List> insert({
    required String groupName,
    required String groupHandle,
  }) async =>
      await supabase.from(TABLE).insert({
        GROUP_NAME: groupName,
        GROUP_HANDLE: groupHandle,
        GROUP_MEMBERS: [userUID],
      }).select();

  Future<List> select({
    String groupUID = '',
  }) async =>
      groupUID.isNotEmpty
          ? await supabase.from(TABLE).select().eq(UID, groupUID)
          : await supabase.from(TABLE).select();

  Future<String> getGroupName(String uid) async =>
      (await select(groupUID: uid)).first[GROUP_NAME];

  Future<List<UserInformationEntity>> getGroupMembers(
    String groupUID,
  ) async {
    final groupRes = await select(groupUID: groupUID);
    if (groupRes.isEmpty) return [];
    final members = groupRes.first[GROUP_MEMBERS];
    final temp = <UserInformationEntity>[];
    for (var member in members) {
      final res = await userInfoQueries.getUserInfo(queryUID: member);
      temp.add(UserInformationModel.fromSupabase(res));
    }
    return temp;
  }

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
