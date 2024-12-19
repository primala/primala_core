import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/home/home.dart';

class HomeContractImpl with ResponseToStatus implements HomeContract {
  final HomeRemoteSource remoteSource;
  final NetworkInfo networkInfo;
  HomeContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });
  @override
  cancelCollaboratorRelationshipsStream(params) async =>
      await remoteSource.cancelCollaboratorRelationshipsStream();

  @override
  cancelCollaboratorRequestsStream(params) async =>
      await remoteSource.cancelCollaboratorRequestsStream();

  @override
  String getUserUID(params) => remoteSource.getUserUID();

  @override
  listenToCollaboratorRelationships(params) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToCollaboratorRelationships();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToCollaboratorRequests(params) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToCollaboratorRequests();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  sendRequest(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.sendRequest(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateRequestStatus(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateRequestStatus(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
