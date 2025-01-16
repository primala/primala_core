import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte_backend/tables/sessions.dart';

class StorageContractImpl
    with ResponseToStatus, SessionsConstants
    implements StorageContract {
  final StorageRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  StorageContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  listenToSessions(params) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSessions(params);
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  createNewGroup(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createNewGroup(params);
      return Right(res != -1 ? true : false);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteGroup(params) async {
    if (await networkInfo.isConnected) {
      await remoteSource.deleteGroup(params);
      return const Right(true);
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
  createQueue(groupUID) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createQueue(groupUID);
      return fromSupabaseProperty<String>(res, '', '');
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
  deleteSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteSession(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelSessionsStream() async => await remoteSource.cancelSessionsStream();

  @override
  updateSessionTitle(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateSessionTitle(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
