import 'package:nokhte_backend/tables/session_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CleanUpSessionsRemoteSource {
  Future<List> deleteActiveNokhteSession();
}

class CleanUpSessionsRemoteSourceImpl implements CleanUpSessionsRemoteSource {
  final SupabaseClient supabase;
  final SessionInformationQueries sessionInformationQueries;
  CleanUpSessionsRemoteSourceImpl({
    required this.supabase,
  }) : sessionInformationQueries =
            SessionInformationQueries(supabase: supabase);

  @override
  deleteActiveNokhteSession() async =>
      await sessionInformationQueries.cleanUpSessions();
}
