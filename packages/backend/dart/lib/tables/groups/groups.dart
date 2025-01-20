// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/tables/groups/groups.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'types/types.dart';

class GroupsQueries with ProfileGradientUtils {
  static const TABLE = 'groups';
  static const ID = 'id';
  static const GROUP_NAME = 'group_name';
  static const GRADIENT = 'gradient';
  static const IS_ADMIN = 'is_admin';

  final SupabaseClient supabase;
  final String userUID;
  final UsersQueries userInfoQueries;

  GroupsQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInfoQueries = UsersQueries(supabase: supabase);

  Future<int> createGroup({
    required String groupName,
  }) async =>
      await supabase.rpc("create_group", params: {
        'p_group_name': groupName,
        'p_user_uid': userUID,
      });

  Future<List> select({
    int groupID = -1,
  }) async =>
      groupID != -1
          ? await supabase.from(TABLE).select().eq(ID, groupID)
          : await supabase.from(TABLE).select();

  Future<List> selectWithStatus() async {
    final res = await select();
    for (var i = 0; i < res.length; i++) {
      final groupID = res[i][ID];
      final isAdmin = await supabase.rpc('is_group_admin', params: {
        '_user_uid': userUID,
        '_group_id': groupID,
      });
      res[i][IS_ADMIN] = isAdmin;
    }
    return res;
  }

// test this
  Future<List> updateGroupName(UpdateGroupNameParams params) async =>
      await supabase
          .from(TABLE)
          .update({GROUP_NAME: params.name})
          .eq(ID, params.groupId)
          .select();

// test this
  Future<List> updateProfileGradient(
          UpdateGroupProfileGradientParams params) async =>
      await supabase
          .from(TABLE)
          .update({
            GRADIENT: mapProfileGradientToString(params.gradient),
          })
          .eq(ID, params.groupId)
          .select();

  Future<String> getGroupName(int id) async =>
      (await select(groupID: id)).first[GROUP_NAME];

  Future<void> delete(int id) async =>
      await supabase.from(TABLE).delete().eq(ID, id);
}
