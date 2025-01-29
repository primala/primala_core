import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte/app/modules/groups/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte_backend/types/user_information_entity.dart';

class UserContractImpl with ResponseToStatus implements UserContract {
  final UserRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  UserContractImpl({required this.remoteSource, required this.networkInfo});

  @override
  deactivateAccount() async {
    await remoteSource.deactivateAccount();
    return const Right(true);
  }

  @override
  getGroupRequests() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getRequests();
      return Right(GroupRequestModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  handleRequest(params) async {
    if (await networkInfo.isConnected) {
      await remoteSource.handleRequest(params);
      return const Right(true);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateActiveGroup(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateActiveGroup(groupId);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateUserProfileGradient(profileGradient) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateUserProfileGradient(profileGradient);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getUserInformation() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getUserInformation();
      return Right(UserInformationModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
