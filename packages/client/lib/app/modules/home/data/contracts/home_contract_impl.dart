import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/groups.dart';

class HomeContractImpl with ResponseToStatus implements HomeContract {
  final HomeRemoteSource remoteSource;
  final NetworkInfo networkInfo;
  HomeContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  listenToSessionRequests(groupId) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSessionRequests(groupId);
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelSessionRequestsStream() async =>
      await remoteSource.cancelSessionRequestsStream();

  @override
  joinSession(sessionId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.joinSession(sessionId);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  initializeSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.initializeSession(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroup(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getGroup(groupId);
      return Right(GroupEntity.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  clearActiveGroup() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.clearActiveGroup();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteStaleSessions() async {
    if (await networkInfo.isConnected) {
      await remoteSource.deleteStaleSessions();
      return const Right(true);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
