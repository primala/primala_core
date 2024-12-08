import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CleanUpCollaborationArtifactsRemoteSource {
  Future<FunctionResponse> deleteActiveNokhteSession();
}

class CleanUpCollaborationArtifactsRemoteSourceImpl
    implements CleanUpCollaborationArtifactsRemoteSource {
  final SupabaseClient supabase;
  final RealtimeActiveSessionQueries irlActiveNokhteSessionQueries;
  CleanUpCollaborationArtifactsRemoteSourceImpl({
    required this.supabase,
  }) : irlActiveNokhteSessionQueries =
            RealtimeActiveSessionQueries(supabase: supabase);

  @override
  deleteActiveNokhteSession() async =>
      await irlActiveNokhteSessionQueries.completeTheSession();
}
