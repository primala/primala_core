import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:nokhte_backend/tables/static_active_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionStartersRemoteSource {
  Future<List> initializeSession(PresetTypes presetType);

  Future<List> updateSessionType(String newPresetUID);

  Future<FunctionResponse> nukeSession();

  Future<FunctionResponse> joinSession(String leaderUID);

  Stream<bool> listenToSessionActivationStatus();

  Future<bool> cancelSessionActivationStream();
}

class SessionStartersRemoteSourceImpl implements SessionStartersRemoteSource {
  final SupabaseClient supabase;
  final String currentUserUID;
  final RealtimeActiveSessionStreams stream;
  final StaticActiveSessionQueries queries;

  SessionStartersRemoteSourceImpl({
    required this.supabase,
  })  : stream = RealtimeActiveSessionStreams(supabase: supabase),
        queries = StaticActiveSessionQueries(supabase: supabase),
        currentUserUID = supabase.auth.currentUser?.id ?? '';

  @override
  cancelSessionActivationStream() async {
    // return await stream.cancelSessionActivationStream();
    return true;
  }

  @override
  Stream<bool> listenToSessionActivationStatus() => const Stream.empty();
  // stream.listenToSessionActivationStatus();

  @override
  initializeSession(param) async => await queries.initializeSession(
        presetType: param,
      );

  @override
  joinSession(String leaderUID) async => FunctionResponse(status: 444);

  @override
  nukeSession() async => await queries.nukeSession();

  @override
  Future<List> updateSessionType(String newPresetUID) async =>
      await queries.updateSessionType(newPresetUID);
}
