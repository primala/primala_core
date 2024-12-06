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
  getNokhteSessionArtifacts(params) async {
    if (await networkInfo.isConnected) {
      final nokhteSessionRes = await remoteSource.getNokhteSessionArtifacts();
      final collaboratorRowsRes = await remoteSource.getCollaboratorRows();
      final userUID = remoteSource.getUserUID();
      return Right(
        NokhteSessionArtifactModel.fromSupabase(
          nokhteSessionRes: nokhteSessionRes,
          collaboratorRowsRes: collaboratorRowsRes,
          userUID: userUID,
        ),
      );
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateSessionAlias(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateSessionAlias(params);
      return fromSupabase(res);
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
      final res = await remoteSource.getGroups();
      return Right(GroupInformationModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
