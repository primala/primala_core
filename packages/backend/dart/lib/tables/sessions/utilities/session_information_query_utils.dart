import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SessionsQueryUtils on SessionsConstants {
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

  Future<T> retry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(T)? shouldRetry,
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      final result = await action();

      if (shouldRetry != null && !shouldRetry(result)) {
        return result;
      }

      attempt++;
      if (attempt >= maxRetries) {
        throw Exception('Operation failed after $maxRetries attempts.');
      }

      await Future.delayed(delay);
    }

    throw Exception('Unexpected retry logic flow');
  }

  bool areListsEqual<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }
}
