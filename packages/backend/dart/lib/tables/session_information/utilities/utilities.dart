import 'package:nokhte_backend/tables/session_information.dart';
export 'session_information_query_utils.dart';

mixin SessionInformationUtils {
  static SessionStatus mapStringToSessionStatus(String status) {
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

  static String mapSessionStatusToString(SessionStatus status) {
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

  static SessionUserStatus mapStringToSessionUserStatus(String status) {
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

  static String mapSessionUserStatusToString(SessionUserStatus status) {
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
}
