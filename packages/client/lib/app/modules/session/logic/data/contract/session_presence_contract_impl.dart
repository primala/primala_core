import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
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
  addContent(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.addContent(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  completeTheSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.completeTheSession();
      return fromFunctionResponse(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToRTSessionMetadata(params) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSessionMetadata();
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateCurrentPhase(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateCurrentPhase(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateOnlineStatus(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateOnlineStatus(params);
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
  cancelSessionMetadataStream(NoParams params) async =>
      await remoteSource.cancelSessionMetadataStream();

  @override
  startTheSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.startTheSession();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getSTSessionMetadata(params) async {
    if (await networkInfo.isConnected) {
      final sessionRes = await remoteSource.getStaticSessionMetadata();
      return Right(
        StaticSessionMetadataModel.fromSupabase(
          sessionRes,
          remoteSource.getUserUID(),
        ),
      );
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

  @override
  updateGroupUID(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupUID(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateQueueUID(params) async {
    if (await networkInfo.isConnected) {
      final queueRes = await remoteSource.updateQueueUID(params.queueUID);
      await remoteSource.setContent(params.content);
      return fromSupabase(queueRes);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  moveQueueToTheTop(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.moveQueueToTheTop(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
