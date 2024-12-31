import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/session_information.dart';

abstract class StorageContract {
  Future<Either<Failure, Stream<GroupSessions>>> listenToSessions(
    String groupUID,
  );

  Future<bool> cancelSessionsStream();

  Future<Either<Failure, bool>> updateGroupMembers(
    UpdateGroupMemberParams params,
  );

  Future<Either<Failure, bool>> deleteSession(
    String params,
  );

  Future<Either<Failure, bool>> updateSessionTitle(
    UpdateSessionTitleParams params,
  );

  Future<Either<Failure, String>> createQueue(
    String groupUID,
  );

  Future<Either<Failure, bool>> deleteQueue(
    String sessionUID,
  );

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
