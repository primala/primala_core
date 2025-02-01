import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';

abstract class DocsContract {
  Future<Either<Failure, Stream<DocumentEntities>>> listenToDocuments(
      int groupId);
  Future<bool> cancelDocumentStream();
}

class DocsContractImpl extends DocsContract {
  final DocsRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  DocsContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  listenToDocuments(int groupId) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToDocuments(groupId);
      return Right(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelDocumentStream() async => await remoteSource.cancelDocumentStream();
}
