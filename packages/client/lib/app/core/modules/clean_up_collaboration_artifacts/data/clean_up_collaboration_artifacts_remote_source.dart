import 'package:nokhte_backend/tables/session_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CleanUpCollaborationArtifactsRemoteSource {
  Future<List> deleteActiveNokhteSession();
}

class CleanUpCollaborationArtifactsRemoteSourceImpl
    implements CleanUpCollaborationArtifactsRemoteSource {
  final SupabaseClient supabase;
  final SessionInformationQueries sessionInformationQueries;
  CleanUpCollaborationArtifactsRemoteSourceImpl({
    required this.supabase,
  }) : sessionInformationQueries =
            SessionInformationQueries(supabase: supabase);

  @override
  deleteActiveNokhteSession() async =>
      await sessionInformationQueries.cleanUpSessions();
}
