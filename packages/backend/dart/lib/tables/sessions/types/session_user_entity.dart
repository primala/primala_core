import 'package:nokhte_backend/types/types.dart';

import 'session_user_status.dart';

class SessionUserEntity extends UserEntity {
  final SessionUserStatus sessionUserStatus;
  SessionUserEntity({
    super.activeGroupId = -1,
    super.email = '',
    required super.profileGradient,
    required super.uid,
    required super.fullName,
    required this.sessionUserStatus,
  });
}
