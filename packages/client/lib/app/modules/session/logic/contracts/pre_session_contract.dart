import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/tables/users.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class PreSessionContract {
  Future<Either<Failure, bool>> initializeSession(
    InitializeSessionParams params,
  );
  Future<Either<Failure, UserEntities>> getGroupMembers(int groupId);
  Future<Either<Failure, DocumentEntities>> getDocuments(int groupId);
  String getUserUid();
}

class PreSessionContractImpl
    with ResponseToStatus
    implements PreSessionContract {
  final PreSessionRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  PreSessionContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  initializeSession(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.initializeSession(params);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getDocuments(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getDocuments(groupId);
      return Right(DocumentEntity.fromSupabaseMultiple(res));
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getGroupMembers(groupId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.getGroupMembers(groupId);
      final usersRes = res.map((e) => e[UsersConstants.S_TABLE]).toList();
      return Right(UserEntity.fromSupabaseMultiple(usersRes));
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getUserUid() => remoteSource.getUserUid();
}
