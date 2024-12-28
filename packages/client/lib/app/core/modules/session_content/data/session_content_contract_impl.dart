import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/modules/session_content/domain/domain.dart';
import 'package:nokhte/app/core/modules/session_content/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

class SessionContentContractImpl
    with ResponseToStatus
    implements SessionContentContract {
  final SessionContentRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  SessionContentContractImpl(
      {required this.remoteSource, required this.networkInfo});

  @override
  listenToSessionContent(sessionUID) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToContent(sessionUID);
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

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
  cancelSessionContentStream() async =>
      await remoteSource.cancelContentStream();
}
