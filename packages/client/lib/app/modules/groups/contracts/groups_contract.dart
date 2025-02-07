import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';

abstract class GroupsContract {
  Future<Either<Failure, int>> createGroup(CreateGroupParams params);
  Future<Either<Failure, Stream<GroupEntities>>> listenToGroups();
  Future<bool> cancelGroupsStream();
  Future<Either<Failure, bool>> deleteGroup(int groupId);
  Future<Either<Failure, bool>> updateGroupName(UpdateGroupNameParams params);
  Future<Either<Failure, bool>> updateGroupProfileGradient(
    UpdateGroupProfileGradientParams params,
  );
}

class GroupsContractImpl with ResponseToStatus implements GroupsContract {
  final GroupsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  GroupsContractImpl({required this.remoteSource, required this.networkInfo});

  @override
  createGroup(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createGroup(params);
      return res != -1
          ? Right(res)
          : Left(FailureConstants.groupCreationFailure);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteGroup(groupId) async {
    if (await networkInfo.isConnected) {
      await remoteSource.deleteGroup(groupId);
      return const Right(true);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToGroups() async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToGroups();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateGroupName(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupName(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateGroupProfileGradient(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupProfileGradient(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  Future<bool> cancelGroupsStream() async =>
      await remoteSource.cancelGroupsStream();
}
