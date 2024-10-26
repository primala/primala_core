import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';

abstract class UserInformationContract {
  Future<Either<Failure, bool>> updatePreferredPreset(String presetUID);
  Future<Either<Failure, PreferredPresetEntity>> getPreferredPreset(
    NoParams params,
  );
  Future<Either<Failure, bool>> checkIfVersionIsUpToDate();
}
