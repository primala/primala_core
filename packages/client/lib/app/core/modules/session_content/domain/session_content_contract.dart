import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

abstract class SessionContentContract {
  Future<Either<Failure, bool>> addContent(AddContentParams params);
  Future<Either<Failure, bool>> updateContent(UpdateContentParams params);
  Future<Either<Failure, bool>> updateParent(UpdateParentParams params);

  Future<Either<Failure, Stream<SessionContentList>>> listenToSessionContent(
    String sessionUID,
  );

  Future<Either<Failure, bool>> deleteContent(String itemUID);

  Future<bool> cancelSessionContentStream();
}
