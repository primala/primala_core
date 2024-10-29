import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';
import 'package:nokhte_backend/tables/st_active_nokhte_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionStartersRemoteSource {
  Future<List> initializeSession();

  Future<List> updateSessionType(String newPresetUID);

  Future<FunctionResponse> nukeSession();

  Future<FunctionResponse> joinSession(String leaderUID);

  Stream<bool> listenToSessionActivationStatus();

  Future<bool> cancelSessionActivationStream();
}

class SessionStartersRemoteSourceImpl implements SessionStartersRemoteSource {
  final SupabaseClient supabase;
  final String currentUserUID;
  final RTActiveNokhteSessionsStream stream;
  final STActiveNokhteSessionQueries queries;

  SessionStartersRemoteSourceImpl({
    required this.supabase,
  })  : stream = RTActiveNokhteSessionsStream(supabase: supabase),
        queries = STActiveNokhteSessionQueries(supabase: supabase),
        currentUserUID = supabase.auth.currentUser?.id ?? '';

  @override
  cancelSessionActivationStream() async {
    return await stream.cancelSessionActivationStream();
  }

  @override
  Stream<bool> listenToSessionActivationStatus() =>
      stream.listenToSessionActivationStatus();

  @override
  initializeSession() async => await queries.initializeSession();

  @override
  joinSession(String leaderUID) async => await queries.joinSession(leaderUID);

  @override
  nukeSession() async => await queries.nukeSession();

  @override
  Future<List> updateSessionType(String newPresetUID) async =>
      await queries.updateSessionType(newPresetUID);
}
