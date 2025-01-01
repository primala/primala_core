import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/modules/clean_up_sessions/clean_up_sessions.dart';
import 'package:nokhte/app/core/network/network_info.dart';

class CleanUpSessionsContractImpl
    with ResponseToStatus
    implements CleanUpSessionsContract {
  final CleanUpSessionsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  CleanUpSessionsContractImpl(
      {required this.remoteSource, required this.networkInfo});

  @override
  cleanUpNokhteSession(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteActiveNokhteSession();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
