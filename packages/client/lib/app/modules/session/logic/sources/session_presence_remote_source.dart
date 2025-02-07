import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionPresenceRemoteSource {
  Future<List> setUserAsCurrentTalker();
  Future<List> clearTheCurrentTalker();
  Stream<SessionMetadata> listenToSessionMetadata();
  Future<bool> cancelSessionMetadataStream();
  Future<List> updateUserStatus(SessionUserStatus params);
  Future<List> letEmCook();
  Future<List> rally(
    RallyParams params,
  );
  String getUserUID();
  Future<List> updateActiveDocument(int docId);
  Future<List> deleteSession(int sessionId);
  Future<List> startTheSession();
  Future<List> updateSpeakingTimerStart();
}

class SessionPresenceRemoteSourceImpl implements SessionPresenceRemoteSource {
  final SupabaseClient supabase;
  final SessionsQueries sessionInformationQueries;
  final SessionsStreams sessionInformationStreams;
  SessionPresenceRemoteSourceImpl({required this.supabase})
      : sessionInformationQueries = SessionsQueries(supabase: supabase),
        sessionInformationStreams = SessionsStreams(supabase: supabase);

  @override
  cancelSessionMetadataStream() =>
      sessionInformationStreams.cancelGetSessionMetadataStream();

  @override
  clearTheCurrentTalker() async => await sessionInformationQueries
      .updateSpeakerSpotlight(addUserToSpotlight: false);

  @override
  listenToSessionMetadata() =>
      sessionInformationStreams.listenToPresenceMetadata();

  @override
  setUserAsCurrentTalker() async =>
      await sessionInformationQueries.updateSpeakerSpotlight(
        addUserToSpotlight: true,
        time: DateTime.now(),
      );

  @override
  deleteSession(docId) async =>
      await sessionInformationQueries.deleteSession(docId);

  @override
  startTheSession() async => await sessionInformationQueries.beginSession();

  @override
  getUserUID() => supabase.auth.currentUser?.id ?? '';

  @override
  letEmCook() async =>
      await sessionInformationQueries.refreshSpeakingTimerStart();

  @override
  rally(params) async =>
      await sessionInformationQueries.updateSecondarySpeakerSpotlight(
        addToSecondarySpotlight: params.shouldAdd,
        secondarySpeakerUID: params.userUID,
      );

  @override
  updateSpeakingTimerStart() async =>
      await sessionInformationQueries.updateSpeakingTimerStart();

  @override
  updateUserStatus(params) async =>
      await sessionInformationQueries.updateUserStatus(params);

  @override
  updateActiveDocument(docId) async {
    return await sessionInformationQueries.updateActiveDocument(docId);
  }
}
