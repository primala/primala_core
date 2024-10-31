import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/network/network_info.dart';

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
  updatePreferredPreset(param) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updatePreferredPreset(param);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getPreferredPreset(params) async {
    if (await networkInfo.isConnected) {
      final presetRes = await remoteSource.getPreferredPreset();
      final userInfoRes = await remoteSource.getUserInfo();

      return Right(PreferredPresetModel.fromSupabase(
        companyPresetRes: presetRes,
        userInformationRes: userInfoRes,
      ));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  checkIfVersionIsUpToDate() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.versionIsUpToDate();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
