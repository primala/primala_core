import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

abstract class StorageContract {
  Future<Either<Failure, List<SessionArtifactEntity>>> getSessions(
      String groupUID);

  Future<Either<Failure, bool>> createNewGroup(
    CreateNewGroupParams params,
  );

  Future<Either<Failure, List<GroupInformationEntity>>> getGroups(
    NoParams params,
  );

  Future<Either<Failure, bool>> deleteGroup(
    String params,
  );
}
