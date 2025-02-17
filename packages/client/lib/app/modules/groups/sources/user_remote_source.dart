import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRemoteSource {
  Future<Map> getUserInformation();
  Future<void> handleRequest(HandleRequestParams params);
  Stream<GroupRequests> listenToRequests();
  Future<FunctionResponse> deleteAccount();
  Future<bool> cancelRequestsStream();
  Future<Map> updateUserProfileGradient(ProfileGradient param);
  Future<Map> updateFullName(String fullName);
  Future<bool> versionIsUpToDate();
  Future<bool> checkIfCanDeleteAccount();
  Future<List> updateActiveGroup(int groupId);
}

class UserRemoteSourceImpl implements UserRemoteSource {
  final SupabaseClient supabase;
  final GroupRequestsQueries groupRequestsQueries;
  final GroupRolesQueries groupRolesQueries;
  final UsersQueries usersQueries;

  UserRemoteSourceImpl({
    required this.supabase,
  })  : groupRequestsQueries = GroupRequestsQueries(supabase: supabase),
        groupRolesQueries = GroupRolesQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase);

  @override
  deleteAccount() async {
    final res = await supabase.functions.invoke('delete-user');
    await supabase.auth.signOut();
    return res;
  }

  @override
  listenToRequests() => groupRequestsQueries.listenToRequests();

  @override
  handleRequest(params) async =>
      await groupRequestsQueries.handleRequest(params);

  @override
  updateActiveGroup(groupId) async =>
      await usersQueries.updateActiveGroup(groupId);

  @override
  updateUserProfileGradient(param) async =>
      await usersQueries.updateProfileGradient(param);

  @override
  getUserInformation() async => await usersQueries.getUserInfo();

  @override
  versionIsUpToDate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return (await supabase.rpc('get_valid_app_versions')).contains(version);
  }

  @override
  cancelRequestsStream() async =>
      await groupRequestsQueries.cancelRequestsStream();

  @override
  checkIfCanDeleteAccount() async =>
      await groupRolesQueries.hasNoGroupMemberships();

  @override
  updateFullName(fullName) async => await usersQueries.updateFullName(fullName);
}
