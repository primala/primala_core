// ignore_for_file: constant_identifier_names, invalid_use_of_internal_member
import 'package:nokhte_backend/tables/groups/groups_queries.dart';
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

  bool groupsListeningStatus = false;

  GroupsQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInfoQueries = UsersQueries(supabase: supabase);

  Future<int> createGroup(CreateGroupParams params) async =>
      await supabase.rpc("create_group", params: {
        'p_profile_gradient': ProfileGradientUtils.mapProfileGradientToString(
          params.profileGradient,
        ),
        'p_group_name': params.groupName,
        'p_user_uid': userUID,
      });

  Future<Map> select({
    int groupId = -1,
  }) async {
    if (groupId == -1) {
      final res = await supabase.from(TABLE).select().single();
      final groupID = res[ID];
      final isAdmin = await supabase.rpc('is_group_admin', params: {
        '_user_uid': userUID,
        '_group_id': groupID,
      });
      res[IS_ADMIN] = isAdmin;
      return res;
    } else {
      final res = await supabase.from(TABLE).select().eq(ID, groupId).single();
      final groupID = res[ID];
      final isAdmin = await supabase.rpc('is_group_admin', params: {
        '_user_uid': userUID,
        '_group_id': groupID,
      });
      res[IS_ADMIN] = isAdmin;
      return res;
    }
  }

  Future<List> selectWithStatus() async {
    final res = await supabase.from(TABLE).select();
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

  Future<bool> cancelGroupsStream() async {
    final res = supabase.realtime.getChannels();
    for (var channel in res) {
      if (channel.topic.contains(TABLE)) {
        channel.unsubscribe();
      }
    }
    groupsListeningStatus = false;
    return groupsListeningStatus;
  }

  Stream<GroupEntities> listenToGroups() async* {
    groupsListeningStatus = true;

    final events = supabase.from(TABLE).stream(primaryKey: ['id']);
    await for (var event in events) {
      if (!groupsListeningStatus) {
        break;
      }
      final temp = <GroupEntity>[];

      if (event.isNotEmpty) {
        for (var row in event) {
          print('what is the row ');
          final isAdmin = await supabase.rpc(
            'is_group_admin',
            params: {
              '_user_uid': userUID,
              '_group_id': row[ID],
            },
          );
          row[IS_ADMIN] = isAdmin;
          temp.add(GroupEntity.fromSupabase(row));
        }
        yield temp;
      } else {
        yield [];
      }
    }
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
            GRADIENT: ProfileGradientUtils.mapProfileGradientToString(
                params.gradient),
          })
          .eq(ID, params.groupId)
          .select();

  Future<String> getGroupName(int id) async =>
      (await select(groupId: id))[GROUP_NAME];

  Future<void> delete(int id) async =>
      await supabase.from(TABLE).delete().eq(ID, id);
}
