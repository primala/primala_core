import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/finished_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/st_active_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/user_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionPresenceRemoteSource {
  Future<List> updateOnlineStatus(bool params);
  Future<List> setUserAsCurrentTalker();
  Future<List> clearTheCurrentTalker();
  Future<List> updateCurrentPhase(double params);
  Stream<NokhteSessionMetadata> listenToSessionMetadata();
  bool cancelSessionMetadataStream();
  Future<List> addContent(String content);
  Future<List> letEmCook();
  Future<List> rally(
    RallyParams params,
  );
  String getUserUID();
  Future<List> getStaticSessionMetadata();
  Future<FunctionResponse> completeTheSession();
  Future<FunctionResponse> startTheSession();
  Future<List> getUserMetadata();
  Future<List> updateSpeakingTimerStart();
}

class SessionPresenceRemoteSourceImpl implements SessionPresenceRemoteSource {
  final SupabaseClient supabase;
  final RTActiveNokhteSessionQueries rtQueries;
  final STActiveNokhteSessionQueries stQueries;
  final RTActiveNokhteSessionsStream stream;
  final FinishedNokhteSessionQueries finishedQueries;
  final UserMetadataQueries userMetadata;
  SessionPresenceRemoteSourceImpl({required this.supabase})
      : rtQueries = RTActiveNokhteSessionQueries(supabase: supabase),
        stQueries = STActiveNokhteSessionQueries(supabase: supabase),
        finishedQueries = FinishedNokhteSessionQueries(supabase: supabase),
        stream = RTActiveNokhteSessionsStream(supabase: supabase),
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
  addContent(content) async => await stQueries.addContent(content);

  @override
  startTheSession() async => await rtQueries.startTheSession();

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
}
