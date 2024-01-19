import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/home/domain/entities/entities.dart';

abstract class HomeContract {
  Future<Either<Failure, bool>> addNameToDatabase(NoParams params);
  Future<Either<Failure, ExistingCollaborationsInfoEntity>>
      getExistingCollaborationInfo(NoParams params);
}
