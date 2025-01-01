import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SessionInformationQueryUtils on SessionInformationConstants {
  SupabaseClient get supabase;

  select() async => await supabase.from(TABLE).select();

  Future<SessionResponse<T>> getProperty<T>(String property) async {
    final row = (await select()).first;
    T prop = row[property];
    final version = row[VERSION];
    return SessionResponse<T>(
      mainType: prop,
      currentVersion: version,
    );
  }
}
