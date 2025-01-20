import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/modules/groups/domain/domain.dart';
import 'package:nokhte/app/modules/groups/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

class GroupsContractImpl with ResponseToStatus implements GroupsContract {
  final GroupsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  GroupsContractImpl({required this.remoteSource, required this.networkInfo});

  @override
  createGroup(groupName) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.createGroup(groupName);
      return res != -1
          ? const Right(true)
          : Left(FailureConstants.groupCreationFailure);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deactivateAccount() async {
    await remoteSource.deactivateAccount();
    return const Right(true);
  }

  @override
  deleteGroup(groupId) async {
    if (await networkInfo.isConnected) {
      await remoteSource.deleteGroup(groupId);
      return const Right(true);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroupRequests() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getRequests();
      return Right(GroupRequestModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroupRoles(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getGroupRoles(groupId);
      return Right(GroupRoleModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroups() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getGroups();
      return Right(GroupModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  handleRequest(params) async {
    if (await networkInfo.isConnected) {
      await remoteSource.handleRequest(params);
      return const Right(true);
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
  sendRequest(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.sendRequest(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateActiveGroup(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateActiveGroup(groupId);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateGroupName(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupName(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateGroupProfileGradient(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateGroupProfileGradient(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateUserProfileGradient(profileGradient) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateUserProfileGradient(profileGradient);
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
}
