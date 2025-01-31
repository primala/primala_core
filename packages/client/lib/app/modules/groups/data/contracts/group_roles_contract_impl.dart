import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte/app/modules/groups/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte_backend/types/types.dart';

class GroupRolesContractImpl
    with ResponseToStatus
    implements GroupRolesContract {
  final GroupRolesRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  GroupRolesContractImpl(
      {required this.remoteSource, required this.networkInfo});

  @override
  getGroupMembers(groupId) async {
    if (await networkInfo.isConnected) {
      final groupMembersRes = await remoteSource.getGroupMembers(groupId);
      final pendingGroupMembersRes = await remoteSource.getPendingMembers(
        groupId,
      );
      final userUid = remoteSource.getUserUid();

      return Right(
        GroupRoleModel.fromSupabase(
          groupMembersRes,
          pendingGroupMembersRes,
          userUid,
        ),
      );
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  removeUserRole(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.removeUserRole(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateUserRole(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateUserRole(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  sendRequests(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.sendRequests(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getUserByEmail(email) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getUserByEmail(email);
      final userUid = remoteSource.getUserUid();
      final model = UserEntity.fromDatabaseFunction(res);
      if (model.uid != userUid) {
        return Right(UserEntity.fromDatabaseFunction(res));
      } else {
        return Left(FailureConstants.lookedThemselvesUpFailure);
      }
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
