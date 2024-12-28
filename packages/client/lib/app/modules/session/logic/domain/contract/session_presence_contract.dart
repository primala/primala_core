import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/session_information.dart';

abstract class SessionPresenceContract {
  Future<Either<Failure, bool>> completeTheSession();
  Future<Either<Failure, bool>> startTheSession();
  Future<Either<Failure, bool>> updateUserStatus(SessionUserStatus params);
  Future<Either<Failure, bool>> usePowerUp(
    Either<LetEmCookParams, RallyParams> params,
  );
  Future<Either<Failure, bool>> updateWhoIsTalking(
      UpdateWhoIsTalkingParams params);

  Future<Either<Failure, Stream<SessionMetadata>>> listenToSessionMetadata();
  Future<bool> cancelSessionMetadataStream();

  Future<Either<Failure, bool>> updateSpeakingTimerStart();
}
