import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/rt_active_nokhte_sessions.dart';

abstract class SessionPresenceContract {
  Future<Either<Failure, bool>> addContent(String params);
  Future<Either<Failure, bool>> completeTheSession(NoParams params);
  Future<Either<Failure, bool>> startTheSession(NoParams params);
  Future<Either<Failure, bool>> updateOnlineStatus(bool params);
  Future<Either<Failure, bool>> usePowerUp(
      Either<LetEmCookParams, RallyParams> params);
  Future<Either<Failure, bool>> updateWhoIsTalking(
      UpdateWhoIsTalkingParams params);
  Future<Either<Failure, bool>> updateCurrentPhase(double params);
  Future<Either<Failure, StaticSessionMetadataEntity>> getSTSessionMetadata(
    NoParams params,
  );
  Future<Either<Failure, Stream<NokhteSessionMetadata>>>
      listenToRTSessionMetadata(NoParams params);
  bool cancelSessionMetadataStream(NoParams params);

  Future<Either<Failure, bool>> updateSpeakingTimerStart();
}
