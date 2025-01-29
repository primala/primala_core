import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte/app/modules/groups/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

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
  Future<bool> cancelGroupsStream() {
    // TODO: implement cancelGroupsStream
    throw UnimplementedError();
  }
}
