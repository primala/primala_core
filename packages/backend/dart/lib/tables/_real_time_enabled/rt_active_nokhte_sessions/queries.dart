import 'package:nokhte_backend/edge_functions/active_nokhte_session.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RTActiveNokhteSessionQueries extends ActiveNokhteSessionEdgeFunctions
    with RTActiveNokhteSessionsConstants, SessionUtils {
  RTActiveNokhteSessionQueries({
    required super.supabase,
  });

  select() async => await supabase.from(TABLE).select();

  Future<SessionResponse<T>> _getProperty<T>(String property) async {
    final row = (await select()).first;
    T prop = row[property];
    final version = row[VERSION];
    return SessionResponse<T>(
      mainType: prop,
      currentVersion: version,
    );
  }

  Future<SessionResponse<List>> getWhoIsOnline() async =>
      await _getProperty(IS_ONLINE);

  Future<SessionResponse<List>> getCurrentPurpose() async =>
      await _getProperty(CURRENT_PURPOSE);

  Future<SessionResponse<String?>> getSpeakerSpotlight() async =>
      await _getProperty(SPEAKER_SPOTLIGHT);

  Future<SessionResponse<List>> getCurrentPhases() async =>
      await _getProperty(CURRENT_PHASES);

  Future<SessionResponse<String>> getSessionUID() async =>
      await _getProperty(SESSION_UID);

  Future<SessionResponse<bool>> getHasBegun() async =>
      await _getProperty(HAS_BEGUN);

  Future<List> updateOnlineStatus(bool isOnlineParam) async {
    await computeCollaboratorInformation();
    final res = await getWhoIsOnline();
    final currentOnlineStatus = res.mainType;
    currentOnlineStatus[userIndex] = isOnlineParam;
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update(
            {
              IS_ONLINE: currentOnlineStatus,
              VERSION: res.currentVersion + 1,
            },
          ),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
      maxRetries: 9,
    );
  }

  Future<List> updateCurrentPhases(double newPhase) async {
    await computeCollaboratorInformation();
    await supabase.rpc('update_nokhte_session_phase', params: {
      'incoming_session_uid': sessionUID,
      'index_to_edit': userIndex,
      'new_value': newPhase,
    });
    return [];
  }

  Future<List> beginSession() async {
    await computeCollaboratorInformation();
    final res = await getWhoIsOnline();
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update({
            HAS_BEGUN: true,
            VERSION: res.currentVersion + 1,
          }),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  Future<List> refreshSpeakingTimerStart() async {
    await computeCollaboratorInformation();
    final res = await getSpeakerSpotlight();
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update(
            {
              SPEAKING_TIMER_START: DateTime.now().toUtc().toIso8601String(),
              VERSION: res.currentVersion + 1,
              SECONDARY_SPEAKER_SPOTLIGHT: userUID,
            },
          ),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
      maxRetries: 9,
    );
  }

  Future<List> updateCurrentPurpose(String newPurpose) async {
    await computeCollaboratorInformation();
    final res = await getSpeakerSpotlight();
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update(
            {
              VERSION: res.currentVersion + 1,
              CURRENT_PURPOSE: newPurpose,
            },
          ),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
      maxRetries: 9,
    );
  }

  Future<List> updateSpeakingTimerStart() async {
    await computeCollaboratorInformation();
    final res = await getSpeakerSpotlight();
    return await retry<List>(
      action: () async {
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update(
            {
              SPEAKING_TIMER_START: DateTime.now().toUtc().toIso8601String(),
              VERSION: res.currentVersion + 1,
            },
          ),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
      maxRetries: 9,
    );
  }

  Future<List> updateSecondarySpeakerSpotlight({
    required bool addToSecondarySpotlight,
    required String secondarySpeakerUID,
  }) async {
    await computeCollaboratorInformation();
    final res = await getSpeakerSpotlight();
    final currentSpotlightSpeaker = res.mainType;
    return await retry<List>(
      action: () async {
        if (addToSecondarySpotlight) {
          if (currentSpotlightSpeaker == userUID) {
            return await _onCurrentActiveNokhteSession(
              supabase.from(TABLE).update(
                {
                  SECONDARY_SPEAKER_SPOTLIGHT: secondarySpeakerUID,
                  VERSION: res.currentVersion + 1,
                },
              ),
              version: res.currentVersion,
            );
          } else {
            return [];
          }
        } else {
          if (currentSpotlightSpeaker == userUID) {
            return await _onCurrentActiveNokhteSession(
              supabase.from(TABLE).update(
                {
                  SECONDARY_SPEAKER_SPOTLIGHT: null,
                  VERSION: res.currentVersion + 1,
                },
              ),
              version: res.currentVersion,
            );
          } else {
            return [];
          }
        }
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  Future<List> updateSpeakerSpotlight({
    required bool addUserToSpotlight,
    DateTime time = const ConstDateTime.fromMillisecondsSinceEpoch(0),
  }) async {
    await computeCollaboratorInformation();
    final res = await getSpeakerSpotlight();
    final currentSpotlightSpeaker = res.mainType;
    return await retry<List>(
      action: () async {
        if (addUserToSpotlight) {
          if (currentSpotlightSpeaker == null) {
            return await _onCurrentActiveNokhteSession(
              supabase.from(TABLE).update(
                {
                  SPEAKER_SPOTLIGHT: userUID,
                  VERSION: res.currentVersion + 1,
                  SPEAKING_TIMER_START: time.toUtc().toIso8601String(),
                },
              ),
              version: res.currentVersion,
            );
          } else {
            return [];
          }
        } else {
          if (currentSpotlightSpeaker == userUID) {
            return await _onCurrentActiveNokhteSession(
              supabase.from(TABLE).update(
                {
                  SPEAKER_SPOTLIGHT: null,
                  VERSION: res.currentVersion + 1,
                  SPEAKING_TIMER_START: null,
                  SECONDARY_SPEAKER_SPOTLIGHT: null,
                },
              ),
              version: res.currentVersion,
            );
          } else {
            return [];
          }
        }
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  Future<List> _onCurrentActiveNokhteSession(
    PostgrestFilterBuilder query, {
    required int version,
  }) async {
    await computeCollaboratorInformation();
    if (sessionUID.isNotEmpty) {
      return await query
          .eq(VERSION, version)
          .eq(SESSION_UID, sessionUID)
          .select();
    } else {
      return [];
    }
  }
}
