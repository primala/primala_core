import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utilities/utilities.dart';

class SessionsQueries
    with SessionsConstants, SessionsUtils, ProfileGradientUtils {
  final SupabaseClient supabase;
  final String userUID;
  int sessionID = -1;
  String userFullName = '';
  int userIndex = -1;
  int groupId = -1;
  final UsersQueries usersQueries;
  SessionsQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        usersQueries = UsersQueries(supabase: supabase);

  getUserInformation() async {
    if (userFullName.isEmpty) {
      userFullName = await usersQueries.getFullName();
      groupId = await usersQueries.getActiveGroup();
    }
  }

  Future<void> deleteStaleSessions() async {
    final currentActiveGroup = await usersQueries.getActiveGroup();
    final res =
        await supabase.from(TABLE).select().eq(GROUP_ID, currentActiveGroup);

    for (var row in res) {
      if (row[STATUS] != mapSessionStatusToString(SessionStatus.recruiting)) {
        await supabase.from(TABLE).delete().eq(ID, row[ID]);
      }

      if (row[COLLABORATOR_UIDS].first == userUID) {
        await supabase.from(TABLE).delete().eq(ID, row[ID]);
      }
    }
  }

  Future<Map> cancelSession(int sessionID) async =>
      await supabase.from(TABLE).delete().eq(ID, sessionID).select().single();

  findCurrentSession() async {
    await getUserInformation();
    if (userIndex == -1 || sessionID == -1) {
      final res = await supabase.from(TABLE).select().eq(
            STATUS,
            mapSessionStatusToString(
              SessionStatus.recruiting,
            ),
          );
      if (res.isNotEmpty) {
        for (var row in res) {
          if (row[COLLABORATOR_UIDS].contains(userUID)) {
            sessionID = row[ID];
            userIndex = row[COLLABORATOR_UIDS].indexOf(userUID);
            break;
          }
        }
      } else {
        final res = await supabase.from(TABLE).select().eq(
              STATUS,
              mapSessionStatusToString(
                SessionStatus.started,
              ),
            );
        for (var row in res) {
          if (row[COLLABORATOR_UIDS].contains(userUID)) {
            sessionID = row[ID];
            userIndex = row[COLLABORATOR_UIDS].indexOf(userUID);
            break;
          }
        }
      }
    }
  }

  resetValues() {
    sessionID = -1;
    userFullName = '';
  }

  select() async => await supabase.from(TABLE).select().eq(ID, sessionID);

  Future<SessionResponse<T>> _getProperty<T>(String property) async {
    final row = (await select()).first;
    T prop = row[property];
    final version = row[VERSION];
    return SessionResponse<T>(
      mainType: prop,
      currentVersion: version,
    );
  }

  Future<SessionResponse<List>> getCollaboratorStatuses() async =>
      await _getProperty(COLLABORATOR_STATUSES);

  Future<SessionResponse<String?>> getSpeakerSpotlight() async =>
      await _getProperty(SPEAKER_SPOTLIGHT);

  Future<SessionResponse<String>> getSessionID() async =>
      await _getProperty(ID);

  Future<SessionResponse<String>> getSessionStatus() async =>
      await _getProperty(STATUS);

  Future<List> updateUserStatus(SessionUserStatus params) async {
    await findCurrentSession();
    final newstatus = mapSessionUserStatusToString(params);
    await supabase.rpc('update_collaborator_status', params: {
      'incoming_session_id': sessionID,
      'index_to_edit': userIndex,
      'new_status': newstatus,
    });
    return [];
  }

  Future<List> beginSession() async {
    await findCurrentSession();
    final res = await getSessionStatus();
    return await retry<List>(
      action: () async {
        final newStatus = mapSessionStatusToString(SessionStatus.started);
        return await _onCurrentActiveNokhteSession(
          supabase.from(TABLE).update(
            {
              STATUS: newStatus,
              VERSION: res.currentVersion + 1,
            },
          ),
          version: res.currentVersion,
        );
      },
      shouldRetry: (result) {
        return result.isEmpty;
      },
    );
  }

  Future<List> refreshSpeakingTimerStart() async {
    await findCurrentSession();
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

  Future<List> updateSpeakingTimerStart() async {
    await findCurrentSession();
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
    await findCurrentSession();
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
    await findCurrentSession();
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

  Future<List> joinSession(int sessionID) async {
    await supabase.rpc('join_session', params: {
      '_session_id': sessionID,
      '_user_uid': userUID,
    });
    return [];
  }

  Future<List> cleanUpSessions() async {
    final activeResponse = await supabase
        .from(TABLE)
        .update({
          STATUS: mapSessionStatusToString(
            SessionStatus.finished,
          )
        })
        .neq(
            STATUS,
            mapSessionStatusToString(
              SessionStatus.dormant,
            ))
        .select();

    return activeResponse;
  }

  Future<Map> initializeSession(InitializeSessionParams params) async {
    final collaboratorUids = params.collaborators.map((e) => e.uid).toList();
    final collaboratorNames =
        params.collaborators.map((e) => e.fullName).toList();
    final profileGradients = params.collaborators
        .map((e) =>
            ProfileGradientUtils.mapProfileGradientToString(e.profileGradient))
        .toList();
    return await supabase
        .from(TABLE)
        .insert({
          COLLABORATOR_UIDS: collaboratorUids,
          DOCUMENTS: params.docIds,
          PROFILE_GRADIENTS: profileGradients,
          COLLABORATOR_NAMES: collaboratorNames,
          COLLABORATOR_STATUSES: List.filled(
            collaboratorUids.length,
            mapSessionUserStatusToString(
              SessionUserStatus.offline,
            ),
          ),
          GROUP_ID: params.groupId,
        })
        .select()
        .single();
  }

  Future<List> _onCurrentActiveNokhteSession(
    PostgrestFilterBuilder query, {
    required int version,
  }) async {
    await findCurrentSession();
    if (sessionID != -1) {
      return await query.eq(VERSION, version).eq(ID, sessionID).select();
    } else {
      return [];
    }
  }
}
