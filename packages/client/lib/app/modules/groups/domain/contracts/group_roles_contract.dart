import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/types/user_information_entity.dart';

abstract class GroupRolesContract {
  Future<Either<Failure, List<GroupRoleEntity>>> getGroupMembers(int groupId);
  Future<Either<Failure, bool>> updateUserRole(UserRoleParams params);
  Future<Either<Failure, bool>> removeUserRole(UserRoleParams params);
  Future<Either<Failure, UserInformationEntity>> getUserByEmail(
    String email,
  );
  Future<Either<Failure, bool>> sendRequests(List<SendRequestParams> params);
}
