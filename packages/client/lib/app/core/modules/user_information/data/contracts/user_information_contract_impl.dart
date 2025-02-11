import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte_backend/types/types.dart';

class UserInformationContractImpl
    with ResponseToStatus
    implements UserInformationContract {
  final UserInformationRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  UserInformationContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  checkIfVersionIsUpToDate() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.versionIsUpToDate();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getUserInformation() async {
    if (await networkInfo.isConnected) {
      final fullName = await remoteSource.getFullName();
      final uid = remoteSource.getUserUID();
      return Right(
        UserEntity(
          activeGroupId: -1,
          email: '',
          fullName: fullName,
          uid: uid,
          profileGradient: ProfileGradient.none,
        ),
      );
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
