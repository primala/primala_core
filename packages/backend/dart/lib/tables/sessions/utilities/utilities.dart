import 'package:nokhte_backend/tables/sessions.dart';
export 'session_information_query_utils.dart';

mixin SessionsUtils {
  SessionStatus mapStringToSessionStatus(String status) {
    switch (status) {
      case 'dormant':
        return SessionStatus.dormant;
      case 'recruiting':
        return SessionStatus.recruiting;
      case 'started':
        return SessionStatus.started;
      case 'finished':
        return SessionStatus.finished;
      default:
        return SessionStatus.none;
    }
  }

  String mapSessionStatusToString(SessionStatus status) {
    switch (status) {
      case SessionStatus.dormant:
        return 'dormant';
      case SessionStatus.recruiting:
        return 'recruiting';
      case SessionStatus.started:
        return 'started';
      case SessionStatus.finished:
        return 'finished';
      default:
        return 'none';
    }
  }

  SessionUserStatus mapStringToSessionUserStatus(String status) {
    switch (status) {
      case 'online':
        return SessionUserStatus.online;
      case 'offline':
        return SessionUserStatus.offline;
      case 'has_joined':
        return SessionUserStatus.hasJoined;
      case 'ready_to_start':
        return SessionUserStatus.readyToStart;
      case 'ready_to_leave':
        return SessionUserStatus.readyToLeave;
      default:
        return SessionUserStatus.none;
    }
  }

  String mapSessionUserStatusToString(SessionUserStatus status) {
    switch (status) {
      case SessionUserStatus.online:
        return 'online';
      case SessionUserStatus.offline:
        return 'offline';
      case SessionUserStatus.hasJoined:
        return 'has_joined';
      case SessionUserStatus.readyToStart:
        return 'ready_to_start';
      case SessionUserStatus.readyToLeave:
        return 'ready_to_leave';
      default:
        return 'none';
    }
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
