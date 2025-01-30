import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

class UserInformationEntity extends Equatable {
  final String uid;
  final ProfileGradient profileGradient;
  final String fullName;
  final String email;
  final int activeGroupId;

  UserInformationEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.profileGradient,
    required this.activeGroupId,
  });

  factory UserInformationEntity.initial() {
    return UserInformationEntity(
      uid: '',
      fullName: '',
      email: '',
      profileGradient: ProfileGradient.none,
      activeGroupId: -1,
    );
  }
  factory UserInformationEntity.fromSupabase(List res) {
    if (res.isEmpty) {
      return UserInformationEntity(
        uid: '',
        email: '',
        fullName: '',
        profileGradient: ProfileGradient.none,
        activeGroupId: -1,
      );
    } else {
      final uid = res.first[UsersConstants.S_UID];
      final name = res.first[UsersConstants.S_FULL_NAME];
      final email = res.first[UsersConstants.S_EMAIL];
      final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
          res.first[UsersConstants.S_GRADIENT]);
      final activeGroupId = res.first[UsersConstants.S_ACTIVE_GROUP] ?? -1;
      return UserInformationEntity(
        uid: uid,
        fullName: name,
        email: email,
        profileGradient: profileGradient,
        activeGroupId: activeGroupId,
      );
    }
  }

  factory UserInformationEntity.fromDatabaseFunction(Map res) {
    if (res[UsersConstants.S_UID] == null) {
      return UserInformationEntity(
        uid: '',
        fullName: '',
        email: '',
        profileGradient: ProfileGradient.none,
        activeGroupId: -1,
      );
    } else {
      final uid = res[UsersConstants.S_UID];
      final name = res[UsersConstants.S_FULL_NAME];
      final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
        res[UsersConstants.S_GRADIENT],
      );
      final email = res[UsersConstants.S_EMAIL];
      final activeGroupId = res[UsersConstants.S_ACTIVE_GROUP] ?? -1;
      return UserInformationEntity(
        uid: uid,
        fullName: name,
        email: email,
        profileGradient: profileGradient,
        activeGroupId: activeGroupId,
      );
    }
  }

  @override
  List<Object> get props => [uid, fullName];
}
