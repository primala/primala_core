// ignore_for_file: constant_identifier_names
import 'package:nokhte_backend/edge_functions/active_nokhte_session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaticActiveSessionQueries extends ActiveSessionEdgeFunctions
    with StaticActiveSessionsConstants, SessionUtils {
  final UserInformationQueries userInformationQueries;
  final RealtimeActiveSessionQueries realtimeQueries;
  final CompanyPresetsQueries companyPresetsQueries;

  StaticActiveSessionQueries({
    required super.supabase,
  })  : userInformationQueries = UserInformationQueries(supabase: supabase),
        companyPresetsQueries = CompanyPresetsQueries(supabase: supabase),
        realtimeQueries = RealtimeActiveSessionQueries(supabase: supabase);

  Future<List> select() async => await supabase.from(TABLE).select();

  Future<SessionResponse<T>> _getProperty<T>(String property) async {
    final row = (await select()).first;
    T prop = row[property];
    final version = row[VERSION];
    return SessionResponse<T>(
      mainType: prop,
      currentVersion: version,
    );
  }

  Future<SessionResponse<String>> getCreatedAt() async =>
      await _getProperty<String>(CREATED_AT);

  Future<SessionResponse<String>> getSessionUID() async =>
      await _getProperty<String>(SESSION_UID);

  Future<SessionResponse<String>> getGroupUID() async =>
      await _getProperty<String>(GROUP_UID);

  Future<SessionResponse<String>> getLeaderUID<String>() async =>
      await _getProperty(LEADER_UID);

  Future<List> initializeSession({
    PresetTypes presetType = PresetTypes.none,
  }) async {
    return await retry<List>(action: () async {
      final fullName = await userInformationQueries.getFullName();
      String preferredPreset = '';
      if (presetType == PresetTypes.none) {
        preferredPreset =
            await userInformationQueries.getPreferredPresetUID() ?? '';
        if (preferredPreset.isEmpty) {
          preferredPreset = (await companyPresetsQueries.select(
                  type: PresetTypes.collaborative))
              .first[CompanyPresetsQueries.UID];
        }
      } else {
        preferredPreset = (await companyPresetsQueries.select(
          type: presetType,
        ))
            .first[CompanyPresetsQueries.UID];
      }

      if (fullName.isEmpty || preferredPreset.isEmpty) return [];

      final staticRes = await supabase.from(TABLE).insert({
        COLLABORATOR_UIDS: [userUID],
        COLLABORATOR_NAMES: [fullName],
        PRESET_UID: preferredPreset,
      }).select();

      if (staticRes.isEmpty) return [];

      final sessionUID = staticRes.first[SESSION_UID];

      return await supabase.from(realtimeQueries.TABLE).insert({
        realtimeQueries.SESSION_UID: sessionUID,
      }).select();
    }, shouldRetry: (result) {
      return result.isEmpty;
    });
  }

  Future<List> updateGroupUID(String newGroupId) async {
    await computeCollaboratorInformation();
    final res = await getCreatedAt();
    final version = res.currentVersion;
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update({
            GROUP_UID: newGroupId,
            VERSION: version + 1,
          }),
          version: version,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  Future<List> updateSessionType(String newPresetUID) async {
    await computeCollaboratorInformation();
    final res = await getCreatedAt();
    final version = res.currentVersion;
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update({
            PRESET_UID: newPresetUID,
            VERSION: version + 1,
          }),
          version: version,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  _onCurrentActiveNokhteSession(
    PostgrestFilterBuilder query, {
    required int version,
  }) async {
    await computeCollaboratorInformation();
    if (userIndex != -1) {
      return await query
          .eq(SESSION_UID, sessionUID)
          .eq(VERSION, version)
          .select();
    } else {
      return [];
    }
  }
}
