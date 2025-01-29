import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/tables/groups.dart';

abstract class GroupsContract {
  Future<Either<Failure, int>> createGroup(CreateGroupParams params);
  Future<Either<Failure, Stream<GroupEntities>>> listenToGroups();
  Future<bool> cancelGroupsStream();
  Future<Either<Failure, bool>> deleteGroup(int groupId);
  Future<Either<Failure, bool>> updateGroupName(UpdateGroupNameParams params);
  Future<Either<Failure, bool>> updateGroupProfileGradient(
    UpdateGroupProfileGradientParams params,
  );
}
