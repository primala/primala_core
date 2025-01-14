import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

abstract class SessionContentContract {
  Future<Either<Failure, bool>> addContent(AddContentParams params);
  Future<Either<Failure, bool>> updateContent(UpdateContentParams params);
  Future<Either<Failure, bool>> updateParent(UpdateParentParams params);

  Future<Either<Failure, Stream<ContentBlockList>>> listenToDocumentContent(
    int documentId,
  );

  Future<Either<Failure, bool>> deleteContent(int contentId);

  Future<bool> cancelSessionContentStream();
}
