import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class UserContract {
  Future<bool> cancelRequestsStream();
  Future<Either<Failure, Stream<GroupRequests>>> listenToRequests();
  Future<Either<Failure, UserEntity>> getUserInformation();
  Future<Either<Failure, bool>> handleRequest(HandleRequestParams params);
  Future<Either<Failure, bool>> deactivateAccount();
  Future<Either<Failure, bool>> updateUserProfileGradient(
    ProfileGradient profileGradient,
  );
  Future<Either<Failure, bool>> checkIfVersionIsUpToDate();
  Future<Either<Failure, bool>> updateActiveGroup(int groupId);
}

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
  listenToRequests() async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToRequests();
      return Right(res);
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
  checkIfVersionIsUpToDate() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.versionIsUpToDate();
      return Right(res);
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
      return Right(UserEntity.fromSupabaseSingle(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelRequestsStream() async => await remoteSource.cancelRequestsStream();
}
