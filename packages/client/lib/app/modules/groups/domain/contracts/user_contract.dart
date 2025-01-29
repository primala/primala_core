import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class UserContract {
  Future<Either<Failure, List<GroupRequestEntity>>> getGroupRequests();
  Future<Either<Failure, UserInformationEntity>> getUserInformation();
  Future<Either<Failure, bool>> handleRequest(HandleRequestParams params);
  Future<Either<Failure, bool>> deactivateAccount();
  Future<Either<Failure, bool>> updateUserProfileGradient(
    ProfileGradient profileGradient,
  );
  Future<Either<Failure, bool>> updateActiveGroup(int groupId);
}
