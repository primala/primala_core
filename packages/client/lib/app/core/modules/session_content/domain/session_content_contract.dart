import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/tables/session_content.dart';

abstract class SessionContentContract {
  Future<Either<Failure, bool>> addContent(AddContentParams params);
  Future<Either<Failure, Stream<SessionContentList>>> listenToSessionContent(
    String sessionUID,
  );
  Future<bool> cancelSessionContentStream();
}
