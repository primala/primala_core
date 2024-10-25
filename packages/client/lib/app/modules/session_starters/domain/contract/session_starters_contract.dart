import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';

abstract class SessionStartersContract {
  Future<Either<Failure, bool>> initializeSession(
      InitializeSessionParams param);
  Future<Either<Failure, bool>> nukeSession(NoParams param);
  Future<Either<Failure, bool>> joinSession(String leaderUID);
  bool cancelSessionActivationStream(NoParams params);
  Future<Either<Failure, Stream<bool>>> listenToSessionActivationStatus(
      NoParams params);
}
