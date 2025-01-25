import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte_backend/tables/group_requests.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class GroupsContract {
  Future<Either<Failure, int>> createGroup(CreateGroupParams params);
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  Future<Either<Failure, bool>> deleteGroup(int groupId);
  Future<Either<Failure, bool>> updateGroupName(UpdateGroupNameParams params);
  Future<Either<Failure, bool>> updateGroupProfileGradient(
    UpdateGroupProfileGradientParams params,
  );

  Future<Either<Failure, List<GroupRoleEntity>>> getGroupRoles(int groupId);
  Future<Either<Failure, bool>> updateUserRole(UserRoleParams params);
  Future<Either<Failure, bool>> removeUserRole(UserRoleParams params);

  Future<Either<Failure, List<GroupRequestEntity>>> getGroupRequests();
  Future<Either<Failure, bool>> handleRequest(HandleRequestParams params);
  Future<Either<Failure, bool>> sendRequest(SendRequestParams params);

  Future<Either<Failure, bool>> deactivateAccount();
  Future<Either<Failure, bool>> updateUserProfileGradient(
    ProfileGradient profileGradient,
  );
  Future<Either<Failure, bool>> updateActiveGroup(int groupId);
}
