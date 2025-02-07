import 'package:nokhte_backend/tables/sessions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CleanUpSessionsRemoteSource {
  Future<List> deleteActiveNokhteSession();
}

class CleanUpSessionsRemoteSourceImpl implements CleanUpSessionsRemoteSource {
  final SupabaseClient supabase;
  final SessionsQueries sessionInformationQueries;
  CleanUpSessionsRemoteSourceImpl({
    required this.supabase,
  }) : sessionInformationQueries = SessionsQueries(supabase: supabase);

  @override
  deleteActiveNokhteSession() async {
    await sessionInformationQueries.deleteStaleSessions();
    return [];
  }
}
