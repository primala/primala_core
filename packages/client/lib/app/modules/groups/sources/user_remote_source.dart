import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRemoteSource {
  Future<List> getUserInformation();
  Future<void> handleRequest(HandleRequestParams params);
  Stream<GroupRequests> listenToRequests();
  Future<void> deactivateAccount();
  Future<bool> cancelRequestsStream();
  Future<List> updateUserProfileGradient(ProfileGradient param);
  Future<List> updateActiveGroup(int groupId);
}

class UserRemoteSourceImpl implements UserRemoteSource {
  final SupabaseClient supabase;
  final GroupRequestsQueries groupRequestsQueries;
  final UsersQueries usersQueries;

  UserRemoteSourceImpl({
    required this.supabase,
  })  : groupRequestsQueries = GroupRequestsQueries(supabase: supabase),
        usersQueries = UsersQueries(supabase: supabase);

  @override
  deactivateAccount() async => await supabase.auth.signOut();

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
  cancelRequestsStream() async =>
      await groupRequestsQueries.cancelRequestsStream();
}
