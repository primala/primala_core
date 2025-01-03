import 'package:nokhte_backend/tables/session_content.dart';
import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/tables/user_information.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utilities/utilities.dart';

class SessionInformationQueries with SessionInformationConstants, SessionUtils {
  final SupabaseClient supabase;
  final String userUID;
  String sessionUID = '';
  String userFullName = '';
  int userIndex = -1;
  final UserInformationQueries userInformationQueries;
  SessionInformationQueries({
    required this.supabase,
  })  : userUID = supabase.auth.currentUser?.id ?? '',
        userInformationQueries = UserInformationQueries(supabase: supabase);

  getUserInformation() async {
    if (userFullName.isEmpty) {
      userFullName = await userInformationQueries.getFullName();
    }
  }

  findCurrentSession() async {
    await getUserInformation();
    if (userIndex == -1 || sessionUID.isEmpty) {
      final res = await supabase.from(TABLE).select().eq(
            STATUS,
            SessionInformationUtils.mapSessionStatusToString(
              SessionStatus.recruiting,
            ),
          );
      if (res.isNotEmpty) {
        for (var row in res) {
          if (row[COLLABORATOR_UIDS].contains(userUID)) {
            sessionUID = row[UID];
            userIndex = row[COLLABORATOR_UIDS].indexOf(userUID);
            break;
          }
        }
      } else {
        final res = await supabase.from(TABLE).select().eq(
              STATUS,
              SessionInformationUtils.mapSessionStatusToString(
                SessionStatus.started,
              ),
            );
        for (var row in res) {
          if (row[COLLABORATOR_UIDS].contains(userUID)) {
            sessionUID = row[UID];
            userIndex = row[COLLABORATOR_UIDS].indexOf(userUID);
            break;
          }
        }
      }
    }
  }

  resetValues() {
    sessionUID = '';
    userFullName = '';
  }

  select() async => await supabase.from(TABLE).select().eq(UID, sessionUID);

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

  Future<SessionResponse<String>> getSessionUID() async =>
      await _getProperty(UID);

  Future<SessionResponse<String>> getSessionTitle() async =>
      await _getProperty(TITLE);

  Future<SessionResponse<String>> getSessionStatus() async =>
      await _getProperty(STATUS);

  Future<List> updateUserStatus(SessionUserStatus params) async {
    await findCurrentSession();
    final newstatus =
        SessionInformationUtils.mapSessionUserStatusToString(params);
    await supabase.rpc('update_collaborator_status', params: {
      'incoming_session_uid': sessionUID,
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
        final newStatus = SessionInformationUtils.mapSessionStatusToString(
            SessionStatus.started);
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

  Future<List> joinSession(String sessionUID) async {
    await supabase.rpc('join_session', params: {
      '_session_uid': sessionUID,
      '_user_uid': userUID,
    });
    return [];
  }

  Future<List> cleanUpSessions() async {
    final activeResponse = await supabase
        .from(TABLE)
        .update({
          STATUS: SessionInformationUtils.mapSessionStatusToString(
            SessionStatus.finished,
          )
        })
        .neq(
            STATUS,
            SessionInformationUtils.mapSessionStatusToString(
              SessionStatus.dormant,
            ))
        .select();
    for (var row in activeResponse) {
      final uid = row[UID];
      final contentRes = await supabase
          .from(SessionContentConstants.S_TABLE)
          .select()
          .eq(UID, uid);
      if (contentRes.isEmpty) {
        await supabase.from(TABLE).delete().eq(UID, uid);
      }
    }
    final dormantResponse = await supabase.from(TABLE).select().eq(
        STATUS,
        SessionInformationUtils.mapSessionStatusToString(
          SessionStatus.dormant,
        ));

    for (var row in dormantResponse) {
      final uid = row[UID];
      final contentRes = await supabase
          .from(SessionContentConstants.S_TABLE)
          .select()
          .eq(UID, uid);
      if (contentRes.isEmpty) {
        await supabase.from(TABLE).delete().eq(UID, uid);
      }
    }

    return activeResponse;
  }

  Future<List> initializeSession(String groupUID) async {
    await getUserInformation();
    return await supabase.from(TABLE).insert({
      COLLABORATOR_UIDS: [userUID],
      COLLABORATOR_NAMES: [userFullName],
      COLLABORATOR_STATUSES: [
        SessionInformationUtils.mapSessionUserStatusToString(
          SessionUserStatus.hasJoined,
        ),
      ],
      GROUP_UID: groupUID,
    }).select();
  }

  Future<List> _onCurrentActiveNokhteSession(
    PostgrestFilterBuilder query, {
    required int version,
  }) async {
    await findCurrentSession();
    if (sessionUID.isNotEmpty) {
      return await query.eq(VERSION, version).eq(UID, sessionUID).select();
    } else {
      return [];
    }
  }
}
