import 'package:nokhte_backend/tables/users.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserInformationRemoteSource {
  Future<String> getFullName();
  Future<bool> versionIsUpToDate();
  String getUserUID();
}

class UserInformationRemoteSourceImpl
    with UsersConstants
    implements UserInformationRemoteSource {
  final SupabaseClient supabase;
  final UsersQueries userInfoQueries;

  UserInformationRemoteSourceImpl({required this.supabase})
      : userInfoQueries = UsersQueries(supabase: supabase);

  @override
  getFullName() async => await userInfoQueries.getFullName();

  @override
  versionIsUpToDate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return (await supabase.rpc('get_valid_app_versions')).contains(version);
  }

  @override
  String getUserUID() => supabase.auth.currentUser?.id ?? '';
}
