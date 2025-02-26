import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/utilities/contract_utils.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';

abstract class DocsContract {
  Future<Either<Failure, Stream<DocumentEntities>>> listenToDocuments(
    int groupId,
  );

  Future<Either<Failure, Stream<DocumentEntities>>> listenToSpecificDocuments(
    List<int> documentIds,
  );

  Future<bool> cancelDocumentStream();

  Future<Either<Failure, bool>> insertDocument(InsertDocumentParams params);
  Future<Either<Failure, bool>> deleteDocument(int documentId);
  Future<Either<Failure, bool>> updateDocumentTitle(
    UpdateDocumentTitleParams params,
  );
  Future<Either<Failure, bool>> toggleArchive(ToggleArchiveParams params);

  Future<Either<Failure, bool>> addContent(AddContentParams params);
  Future<Either<Failure, bool>> updateContent(UpdateContentParams params);
  Future<Either<Failure, bool>> deleteContent(int contentId);

  Future<Either<Failure, Stream<ContentBlocks>>> listenToDocumentContent(
    int documentId,
  );
  Future<bool> cancelContentStream();
}

class DocsContractImpl extends DocsContract
    with ResponseToStatus, ContractUtils {
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
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  cancelDocumentStream() async => await remoteSource.cancelDocumentStream();

  @override
  insertDocument(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.insertDocument(params);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  deleteDocument(documentId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteDocument(documentId);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  addContent(params) async => handleRemoteOperation<Map>(
        operation: () => remoteSource.addContent(params),
        failure: FailureConstants.addContentFailure,
        networkInfo: networkInfo,
      ).then((result) => result.fold(
            (failure) => Left(failure),
            (success) => fromSupabaseSingle(success),
          ));

  @override
  cancelContentStream() async => await remoteSource.cancelContentStream();

  @override
  deleteContent(contentId) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.deleteContent(contentId);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToDocumentContent(documentId) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToDocumentContent(documentId);
      return Right(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  updateContent(params) async => handleRemoteOperation<Map>(
        operation: () => remoteSource.updateContent(params),
        failure: FailureConstants.updateContentFailure,
        networkInfo: networkInfo,
      ).then((result) => result.fold(
            (failure) => Left(failure),
            (success) => fromSupabaseSingle(success),
          ));

  @override
  updateDocumentTitle(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.updateDocumentTitle(params);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  listenToSpecificDocuments(documentIds) async {
    if (await networkInfo.isConnected) {
      final res = remoteSource.listenToSpecificDocuments(documentIds);
      return Right(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  toggleArchive(params) async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.toggleArchive(params);
      return fromSupabaseSingle(res);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }
}
