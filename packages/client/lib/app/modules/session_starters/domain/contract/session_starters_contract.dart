import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

abstract class SessionStartersContract {
  Future<Either<Failure, bool>> initializeSession(
      Either<NoParams, PresetTypes> params);
  Future<Either<Failure, bool>> nukeSession(NoParams param);
  Future<Either<Failure, bool>> joinSession(String leaderUID);
  Future<Either<Failure, bool>> updateSessionType(String newPresetUID);
  bool cancelSessionActivationStream(NoParams params);

  Future<Either<Failure, Stream<bool>>> listenToSessionActivationStatus(
      NoParams params);
}
