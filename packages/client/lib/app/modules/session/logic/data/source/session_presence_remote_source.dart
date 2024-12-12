import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/finished_sessions.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:nokhte_backend/tables/static_active_sessions.dart';
import 'package:nokhte_backend/tables/user_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionPresenceRemoteSource {
  Future<List> updateOnlineStatus(bool params);
  Future<List> setUserAsCurrentTalker();
  Future<List> clearTheCurrentTalker();
  Future<List> updateCurrentPhase(double params);
  Stream<SessionMetadata> listenToSessionMetadata();
  Future<bool> cancelSessionMetadataStream();
  Future<List> addContent(AddContentParams content);
  Future<List> letEmCook();
  Future<List> rally(
    RallyParams params,
  );
  String getUserUID();
  Future<List> getStaticSessionMetadata();
  Future<FunctionResponse> completeTheSession();
  Future<List> startTheSession();
  Future<List> getUserMetadata();
  Future<List> updateSpeakingTimerStart();
  Future<List> updateGroupUID(String params);
  Future<List> updateQueueUID(String params);
  Future<List> setContent(List params);
}

class SessionPresenceRemoteSourceImpl implements SessionPresenceRemoteSource {
  final SupabaseClient supabase;
  final RealtimeActiveSessionQueries rtQueries;
  final StaticActiveSessionQueries stQueries;
  final RealtimeActiveSessionStream stream;
  final FinishedSessionsQueries finishedQueries;
  final UserMetadataQueries userMetadata;
  SessionPresenceRemoteSourceImpl({required this.supabase})
      : rtQueries = RealtimeActiveSessionQueries(supabase: supabase),
        stQueries = StaticActiveSessionQueries(supabase: supabase),
        finishedQueries = FinishedSessionsQueries(supabase: supabase),
        stream = RealtimeActiveSessionStream(supabase: supabase),
        userMetadata = UserMetadataQueries(supabase: supabase);

  @override
  cancelSessionMetadataStream() => stream.cancelGetSessionMetadataStream();

  @override
  clearTheCurrentTalker() async =>
      await rtQueries.updateSpeakerSpotlight(addUserToSpotlight: false);

  @override
  listenToSessionMetadata() => stream.listenToPresenceMetadata();

  @override
  setUserAsCurrentTalker() async => await rtQueries.updateSpeakerSpotlight(
        addUserToSpotlight: true,
        time: DateTime.now(),
      );

  @override
  updateCurrentPhase(params) async =>
      await rtQueries.updateCurrentPhases(params);

  @override
  updateOnlineStatus(params) async => await rtQueries.updateOnlineStatus(
        params,
      );

  @override
  completeTheSession() async => await rtQueries.completeTheSession();

  @override
  addContent(param) async => await rtQueries.addContent(
        param.content,
        insertionIndex: param.insertAt,
      );

  @override
  startTheSession() async => await rtQueries.beginSession();

  @override
  getUserUID() => supabase.auth.currentUser?.id ?? '';

  @override
  getStaticSessionMetadata() async => await stQueries.select();

  @override
  getUserMetadata() async => await userMetadata.getUserMetadata();

  @override
  letEmCook() async => await rtQueries.refreshSpeakingTimerStart();

  @override
  rally(params) async {
    return await rtQueries.updateSecondarySpeakerSpotlight(
      addToSecondarySpotlight: params.shouldAdd,
      secondarySpeakerUID: params.userUID,
    );
  }

  @override
  updateSpeakingTimerStart() async =>
      await rtQueries.updateSpeakingTimerStart();

  @override
  updateGroupUID(params) async => await stQueries.updateGroupUID(params);

  @override
  setContent(params) async => await rtQueries.setContent(params);

  @override
  updateQueueUID(params) async => await stQueries.updateQueueUID(params);
}
