import 'package:nokhte/app/core/modules/hive/hive.dart';
import 'package:nokhte/app/core/modules/hive/mixin/mixin.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/finished_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserInformationRemoteSource {
  Future<List> updatePreferredPreset(String presetUID);
  Future<List> getUserInfo();
  Future<bool> versionIsUpToDate();
  Future<List> getPreferredPreset();
}

class UserInformationRemoteSourceImpl
    with HiveBoxUtils, UserInformationConstants
    implements UserInformationRemoteSource {
  final SupabaseClient supabase;
  final UserInformationQueries userInfoQueries;
  final FinishedNokhteSessionQueries finishedNokhteSessionQueries;
  final CompanyPresetsQueries companyPresetQueries;
  final userInfoBox = HiveBoxes.userInformation.toString();

  UserInformationRemoteSourceImpl({required this.supabase})
      : userInfoQueries = UserInformationQueries(supabase: supabase),
        companyPresetQueries = CompanyPresetsQueries(supabase: supabase),
        finishedNokhteSessionQueries =
            FinishedNokhteSessionQueries(supabase: supabase);

  @override
  getUserInfo() async => await userInfoQueries.getUserInfo();

  @override
  updatePreferredPreset(String presetUID) async =>
      await userInfoQueries.updatePreferredPreset(presetUID);

  @override
  versionIsUpToDate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return (await supabase.rpc('get_valid_app_versions')).contains(version);
  }

  @override
  Future<List> getPreferredPreset() async {
    final res = await userInfoQueries.getUserInfo();
    final presetUID = res.first[userInfoQueries.PREFERRED_PRESET];
    if (presetUID == null) return [];
    return await companyPresetQueries.select(
      uid: presetUID,
    );
  }
}
