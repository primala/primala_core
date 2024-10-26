// ignore_for_file: overridden_fields

import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
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
  Future<Either<Failure, bool>> addContent(String params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.addContent(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  Future<Either<Failure, bool>> completeTheSession(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.completeTheSession();
      return fromFunctionResponse(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToRTSessionMetadata(NoParams params) async {
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
  cancelSessionMetadataStream(NoParams params) =>
      remoteSource.cancelSessionMetadataStream();

  @override
  startTheSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.startTheSession();
      return fromFunctionResponse(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getSTSessionMetadata(params) async {
    if (await networkInfo.isConnected) {
      final sessionRes = await remoteSource.getStaticSessionMetadata();
      final metadataRes = await remoteSource.getUserMetadata();
      return Right(
          StaticSessionMetadataModel.fromSupabase(sessionRes, metadataRes));
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
