import 'package:nokhte_backend/types/types.dart';

import 'session_user_status.dart';

class SessionUserInfoEntity extends UserInformationEntity {
  final SessionUserStatus sessionUserStatus;
  SessionUserInfoEntity({
    super.email = '',
    super.profileGradient = ProfileGradient.none,
    required super.uid,
    required super.fullName,
    required this.sessionUserStatus,
  });
}
