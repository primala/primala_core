import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/presets/domain/domain.dart';

abstract class PresetsContract {
  Future<Either<Failure, CompanyPresetsEntity>> getPresets(
    Either<GetAllPresetsParams, String> params,
  );

  Future<Either<Failure, bool>> upsertSessionPreferences(
    UpsertSessionPreferencesParams params,
  );
}
