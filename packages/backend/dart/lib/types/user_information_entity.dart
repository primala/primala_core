import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/user_information.dart';

class UserInformationEntity extends Equatable {
  final String uid;
  final String fullName;

  UserInformationEntity({
    required this.uid,
    required this.fullName,
  });

  factory UserInformationEntity.initial() {
    return UserInformationEntity(
      uid: '',
      fullName: '',
    );
  }

  @override
  List<Object> get props => [uid, fullName];
}

class UserInformationModel extends UserInformationEntity {
  UserInformationModel({
    required super.uid,
    required super.fullName,
  });

  factory UserInformationModel.fromSupabase(List response) {
    if (response.isEmpty) {
      return UserInformationModel(
        uid: '',
        fullName: '',
      );
    } else {
      final uid = response.first[UserInformationConstants.S_UID];
      final fName = response.first[UserInformationConstants.S_FIRST_NAME];
      final lName = response.first[UserInformationConstants.S_LAST_NAME];
      return UserInformationModel(
        uid: uid,
        fullName: '$fName $lName',
      );
    }
  }
}
