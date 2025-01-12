// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupsQueries {
  static const TABLE = 'groups';
  static const ID = 'id';
  static const CREATOR_UID = 'creator_uid';
  static const GROUP_NAME = 'group_name';

  final SupabaseClient supabase;
  final String userUID;
  final UsersQueries userInfoQueries;

  GroupsQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInfoQueries = UsersQueries(supabase: supabase);

  Future<List> insert({
    required String groupName,
  }) async =>
      await supabase.from(TABLE).insert({
        GROUP_NAME: groupName,
      }).select();

  Future<List> select({
    int groupID = -1,
  }) async =>
      groupID != -1
          ? await supabase.from(TABLE).select().eq(ID, groupID)
          : await supabase.from(TABLE).select();

  Future<String> getGroupName(int id) async =>
      (await select(groupID: id)).first[GROUP_NAME];

  Future<List> delete({
    required int id,
  }) async =>
      await supabase.from(TABLE).delete().eq(ID, id).select();
}
