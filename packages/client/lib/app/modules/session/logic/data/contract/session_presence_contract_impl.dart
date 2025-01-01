import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionPresenceContractImpl
    with ResponseToStatus, FromFinishedSessions
    implements SessionPresenceContract {
  final SessionPresenceRemoteSource remoteSource;
  final NetworkInfo networkInfo;
  SessionPresenceContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  completeTheSession() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.completeTheSession();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToSessionMetadata() async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSessionMetadata();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateUserStatus(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateUserStatus(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateWhoIsTalking(params) async {
    if (await networkInfo.isConnected) {
      switch (params) {
        case UpdateWhoIsTalkingParams.setUserAsTalker:
          final res = await remoteSource.setUserAsCurrentTalker();
          return fromSupabase(res);
        case UpdateWhoIsTalkingParams.clearOut:
          await remoteSource.clearTheCurrentTalker();
          return const Right(true);
      }
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelSessionMetadataStream() async =>
      await remoteSource.cancelSessionMetadataStream();

  @override
  startTheSession() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.startTheSession();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  usePowerUp(params) async {
    if (await networkInfo.isConnected) {
      return params.fold((letEmCook) async {
        final res = await remoteSource.letEmCook();
        return fromSupabase(res);
      }, (rally) async {
        final res = await remoteSource.rally(rally);
        return fromSupabase(res);
      });
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateSpeakingTimerStart() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateSpeakingTimerStart();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
