import 'package:nokhte_backend/tables/session_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionContentRemoteSource {
  Stream<SessionContentList> listenToContent(String sessionUID);
  Future<bool> cancelContentStream();
  Future<List> addContent(AddContentParams params);
}

class SessionContentRemoteSourceImpl implements SessionContentRemoteSource {
  final SupabaseClient supabase;
  final SessionContentQueries sessionContentQueries;
  final SessionContentStreams sessionContentStreams;

  SessionContentRemoteSourceImpl({
    required this.supabase,
  })  : sessionContentQueries = SessionContentQueries(supabase: supabase),
        sessionContentStreams = SessionContentStreams(supabase: supabase);

  @override
  addContent(param) async => await sessionContentQueries.addContent(param);

  @override
  cancelContentStream() async =>
      await sessionContentStreams.cancelContentListeningStream();

  @override
  listenToContent(sessionUID) {
    sessionContentQueries.setSessionUID(sessionUID);
    return sessionContentStreams.listenToContent(sessionUID);
  }
}
