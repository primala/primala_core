import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

abstract class PosthogContract {
  Future<Either<Failure, Null>> identifyUser(NoParams params);
  Future<Either<Failure, Null>> captureSessionStart(
    CaptureSessionStartParams params,
  );
  Future<Either<Failure, Null>> captureSessionEnd(
      CaptureSessionEndParams params);
  Future<Either<Failure, Null>> captureScreen(String screenRoute);
  Future<Either<Failure, Null>> captureCreateDoc();
}

class PosthogContractImpl implements PosthogContract {
  final PosthogRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  PosthogContractImpl({required this.remoteSource, required this.networkInfo});

  @override
  captureSessionEnd(startTime) async {
    if (await networkInfo.isConnected) {
      await remoteSource.captureSessionEnd(startTime);
      return const Right(null);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  captureSessionStart(params) async {
    if (await networkInfo.isConnected) {
      await remoteSource.captureSessionStart(params);
      return const Right(null);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  identifyUser(params) async {
    if (await networkInfo.isConnected) {
      await remoteSource.identifyUser();
      return const Right(null);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  captureScreen(screen) async {
    if (await networkInfo.isConnected) {
      await remoteSource.captureScreen(screen);
      return const Right(null);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  captureCreateDoc() async {
    if (await networkInfo.isConnected) {
      await remoteSource.captureCreateDoc();
      return const Right(null);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }
}
