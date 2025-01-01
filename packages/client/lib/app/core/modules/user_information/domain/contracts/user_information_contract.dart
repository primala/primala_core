import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class UserInformationContract {
  Future<Either<Failure, bool>> checkIfVersionIsUpToDate();
  Future<Either<Failure, UserInformationEntity>> getUserInformation();
}
