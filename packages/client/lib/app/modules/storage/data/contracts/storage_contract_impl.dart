import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte/app/core/network/network_info.dart';

class StorageContractImpl with ResponseToStatus implements StorageContract {
  final StorageRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  StorageContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  getSessions(params) async {
    if (await networkInfo.isConnected) {
      final nokhteSessionRes = await remoteSource.getSessions(params);
      return Right(
        SessionArtifactModel.fromSupabase(
          nokhteSessionRes,
        ),
      );
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  createNewGroup(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createNewGroup(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteGroup(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteGroup(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroups(params) async {
    if (await networkInfo.isConnected) {
      final groupResponse = await remoteSource.getGroups();
      final collaborators = await _getCollaborators();
      return Right(
          GroupInformationModel.fromSupabase(groupResponse, collaborators));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  createQueue(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createQueue(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteQueue(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteQueue(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getQueues(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getQueues(params);
      return Right(QueueModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateGroupMembers(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupMembers(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  _getCollaborators() async {
    final res = await remoteSource.getCollaborators();
    return CollaboratorModel.fromSupabase(res);
  }

  @override
  deleteSession(String params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteSession(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
