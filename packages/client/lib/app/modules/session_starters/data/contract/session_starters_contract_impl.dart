import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class SessionStartersContractImpl
    with ResponseToStatus
    implements SessionStartersContract {
  final SessionStartersRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  SessionStartersContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  cancelSessionActivationStream(NoParams params) async =>
      await remoteSource.cancelSessionActivationStream();

  @override
  listenToSessionActivationStatus(NoParams params) async {
    if (await networkInfo.isConnected) {
      return Right(remoteSource.listenToSessionActivationStatus());
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  initializeSession(param) async {
    if (await networkInfo.isConnected) {
      final rsParams =
          param.fold((noParam) => PresetTypes.none, (presetType) => presetType);
      final res = await remoteSource.initializeSession(rsParams);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  joinSession(String leaderUID) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.joinSession(leaderUID);
      return fromFunctionResponse(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  nukeSession(param) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.nukeSession();
      return fromFunctionResponse(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
    //
  }

  @override
  updateSessionType(newPresetUID) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateSessionType(newPresetUID);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
