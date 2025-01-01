import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';

abstract class CleanUpSessionsContract {
  Future<Either<Failure, bool>> cleanUpNokhteSession(NoParams params);
}
