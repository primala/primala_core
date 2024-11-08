import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';

abstract class PosthogContract {
  Future<Either<Failure, Null>> identifyUser(NoParams params);
  Future<Either<Failure, Null>> captureSessionStart(
    CaptureSessionStartParams params,
  );
  Future<Either<Failure, Null>> captureSessionEnd(
      CaptureSessionEndParams params);
  Future<Either<Failure, Null>> captureScreen(String screenRoute);
}
