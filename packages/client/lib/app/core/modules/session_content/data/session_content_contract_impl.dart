import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/modules/session_content/domain/domain.dart';
import 'package:nokhte/app/core/modules/session_content/data/data.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';

class SessionContentContractImpl
    with ResponseToStatus
    implements SessionContentContract {
  final SessionContentRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  SessionContentContractImpl(
      {required this.remoteSource, required this.networkInfo});

  @override
  listenToDocumentContent(documentId) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToDocumentContent(documentId);
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  addContent(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.addContent(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelSessionContentStream() async =>
      await remoteSource.cancelContentStream();

  @override
  updateContent(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateContent(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateParent(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateParent(params);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteContent(contentId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteContent(contentId);
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }
}
