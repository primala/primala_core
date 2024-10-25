import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionStartersRemoteSource {
  Future<FunctionResponse> initializeSession(InitializeSessionParams param);

  Future<FunctionResponse> nukeSession();

  Future<FunctionResponse> joinSession(String leaderUID);

  Stream<bool> listenToSessionActivationStatus();

  bool cancelSessionActivationStream();
}

class SessionStartersRemoteSourceImpl implements SessionStartersRemoteSource {
  final SupabaseClient supabase;
  final String currentUserUID;
  final RTActiveNokhteSessionsStream stream;
  final RTActiveNokhteSessionQueries queries;

  SessionStartersRemoteSourceImpl({
    required this.supabase,
  })  : stream = RTActiveNokhteSessionsStream(supabase: supabase),
        queries = RTActiveNokhteSessionQueries(supabase: supabase),
        currentUserUID = supabase.auth.currentUser?.id ?? '';

  @override
  bool cancelSessionActivationStream() {
    return stream.cancelSessionActivationStream();
  }

  @override
  Stream<bool> listenToSessionActivationStatus() =>
      stream.listenToSessionActivationStatus();

  @override
  initializeSession(param) async => await queries.initializeSession(
        presetType:
            param.fold((_) => PresetTypes.none, (presetType) => presetType),
      );

  @override
  joinSession(String leaderUID) async => await queries.joinSession(leaderUID);

  @override
  nukeSession() async => await queries.nukeSession();
}
