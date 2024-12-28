import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionPresenceRemoteSource {
  Future<List> setUserAsCurrentTalker();
  Future<List> clearTheCurrentTalker();
  Stream<SessionMetadata> listenToSessionMetadata();
  Future<bool> cancelSessionMetadataStream();
  Future<bool> cancelSessionContentStream();
  Future<List> updateUserStatus(SessionUserStatus params);
  Future<List> addContent(AddContentParams content);
  Future<List> letEmCook();
  Future<List> rally(
    RallyParams params,
  );
  String getUserUID();
  Future<List> completeTheSession();
  Future<List> startTheSession();
  Future<List> updateSpeakingTimerStart();
  Stream<List<ContentBlock>> listenToSessionContent(String params);
}

class SessionPresenceRemoteSourceImpl implements SessionPresenceRemoteSource {
  final SupabaseClient supabase;
  final SessionInformationQueries sessionInformationQueries;
  final SessionInformationStreams sessionInformationStreams;
  final SessionContentQueries sessionContentQueries;
  final SessionContentStreams sessionContentStreams;
  SessionPresenceRemoteSourceImpl({required this.supabase})
      : sessionInformationQueries =
            SessionInformationQueries(supabase: supabase),
        sessionContentQueries = SessionContentQueries(supabase: supabase),
        sessionContentStreams = SessionContentStreams(supabase: supabase),
        sessionInformationStreams =
            SessionInformationStreams(supabase: supabase);

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
  completeTheSession() async =>
      await sessionInformationQueries.cleanUpSessions();

  @override
  addContent(param) async => await sessionContentQueries.addContent(param);

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
  listenToSessionContent(params) =>
      sessionContentStreams.listenToContent(params);

  @override
  cancelSessionContentStream() async =>
      await sessionContentStreams.cancelContentListeningStream();
}
