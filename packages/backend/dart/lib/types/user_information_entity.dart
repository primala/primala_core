import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:nokhte_backend/utils/profile_gradients_utils.dart';

class UserInformationEntity extends Equatable {
  final String uid;
  final ProfileGradient profileGradient;
  final String fullName;
  final String email;

  UserInformationEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.profileGradient,
  });

  factory UserInformationEntity.initial() {
    return UserInformationEntity(
      uid: '',
      fullName: '',
      email: '',
      profileGradient: ProfileGradient.none,
    );
  }

  @override
  List<Object> get props => [uid, fullName];
}

class UserInformationModel extends UserInformationEntity {
  UserInformationModel({
    required super.uid,
    required super.email,
    required super.fullName,
    required super.profileGradient,
  });

  factory UserInformationModel.fromSupabase(List res) {
    if (res.isEmpty) {
      return UserInformationModel(
        uid: '',
        email: '',
        fullName: '',
        profileGradient: ProfileGradient.none,
      );
    } else {
      final uid = res.first[UsersConstants.S_UID];
      final name = res.first[UsersConstants.S_FULL_NAME];
      final email = res.first[UsersConstants.S_EMAIL];
      final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
          res.first[UsersConstants.S_GRADIENT]);
      return UserInformationModel(
        uid: uid,
        fullName: name,
        email: email,
        profileGradient: profileGradient,
      );
    }
  }

  factory UserInformationModel.fromDatabaseFunction(Map res) {
    if (res[UsersConstants.S_UID] == null) {
      return UserInformationModel(
        uid: '',
        fullName: '',
        email: '',
        profileGradient: ProfileGradient.none,
      );
    } else {
      final uid = res[UsersConstants.S_UID];
      final name = res[UsersConstants.S_FULL_NAME];
      final profileGradient = ProfileGradientUtils.mapStringToProfileGradient(
        res[UsersConstants.S_GRADIENT],
      );
      final email = res[UsersConstants.S_EMAIL];
      return UserInformationModel(
        uid: uid,
        fullName: name,
        email: email,
        profileGradient: profileGradient,
      );
    }
  }
}
