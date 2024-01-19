import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/core/modules/delete_unconsecrated_collaborations/data/data.dart';
import 'package:nokhte/app/core/modules/delete_unconsecrated_collaborations/domain/domain.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

class DeleteUnconsecratedCollaborationsContractImpl
    with ResponseToStatus
    implements DeleteUnconsecratedCollaborationsContract {
  final DeleteUnconsecratedCollaborationsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  DeleteUnconsecratedCollaborationsContractImpl(
      {required this.remoteSource, required this.networkInfo});

  @override
  deleteCapsuleArrangement(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteCapsuleArrangement();
      return Right(fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteCollaborativeDocument(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteCollaborativeDocument();
      return Right(fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteSchedulingSession(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteSchedulingSession();
      return Right(fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteSoloDocument(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteSoloDocument();
      return Right(fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteTheCollaboration(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteTheCollaboration();
      return Right(fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  checkForUnconsecratedCollaboration(NoParams params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.checkForUnconsecratedCollaboration();
      return Right(UnconsecratedCollaborationCheckerModel.fromSupabase(res));
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
