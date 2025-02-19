import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';

abstract class SessionPresenceContract {
  Future<Either<Failure, bool>> deleteSession(int sessionId);
  Future<Either<Failure, bool>> updateActiveDocument(int docId);
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

class SessionPresenceContractImpl
    with ResponseToStatus
    implements SessionPresenceContract {
  final SessionPresenceRemoteSource remoteSource;
  final NetworkInfo networkInfo;
  SessionPresenceContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  deleteSession(sessionId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteSession(sessionId);
      return fromSupabase(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToSessionMetadata() async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSessionMetadata();
      return Right(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateUserStatus(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateUserStatus(params);
      return fromSupabase(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
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
      return const Left(FailureConstants.internetConnectionFailure);
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
      return const Left(FailureConstants.internetConnectionFailure);
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
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateSpeakingTimerStart() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateSpeakingTimerStart();
      return fromSupabase(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateActiveDocument(docId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateActiveDocument(docId);
      return fromSupabase(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }
}
