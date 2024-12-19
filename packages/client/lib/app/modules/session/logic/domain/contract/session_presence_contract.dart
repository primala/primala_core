import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';

abstract class SessionPresenceContract {
  Future<Either<Failure, bool>> addContent(AddContentParams params);
  Future<Either<Failure, bool>> moveQueueToTheTop(MoveQueueToTopParams params);
  Future<Either<Failure, bool>> completeTheSession(NoParams params);
  Future<Either<Failure, bool>> startTheSession(NoParams params);
  Future<Either<Failure, bool>> updateOnlineStatus(bool params);
  Future<Either<Failure, bool>> updateGroupUID(String params);
  Future<Either<Failure, bool>> updateQueueUID(UpdateQueueUIDParams params);
  Future<Either<Failure, bool>> usePowerUp(
    Either<LetEmCookParams, RallyParams> params,
  );
  Future<Either<Failure, bool>> updateWhoIsTalking(
      UpdateWhoIsTalkingParams params);
  Future<Either<Failure, bool>> updateCurrentPhase(double params);
  Future<Either<Failure, StaticSessionMetadataEntity>> getSTSessionMetadata(
    NoParams params,
  );
  Future<Either<Failure, Stream<SessionMetadata>>> listenToRTSessionMetadata(
    NoParams params,
  );
  Future<bool> cancelSessionMetadataStream(NoParams params);

  Future<Either<Failure, bool>> updateSpeakingTimerStart();
}
