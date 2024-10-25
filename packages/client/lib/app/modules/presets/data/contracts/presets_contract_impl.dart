import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/presets/domain/domain.dart';
import 'package:nokhte/app/modules/presets/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:dartz/dartz.dart';

class PresetsContractImpl with ResponseToStatus implements PresetsContract {
  final PresetsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  PresetsContractImpl({required this.remoteSource, required this.networkInfo});

  @override
  getPresets(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource
          .getCompanyPresets(params.fold((_) => '', (uid) => uid));
      return Right(CompanyPresetsModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  upsertSessionPreferences(UpsertSessionPreferencesParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.upsertSessionPreferences(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
