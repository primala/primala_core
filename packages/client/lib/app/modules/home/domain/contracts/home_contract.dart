import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';

abstract class HomeContract {
  Future<Either<Failure, Stream<SessionRequest>>> listenToSessionRequests(
      int groupId);
  Future<bool> cancelSessionRequestsStream();
  Future<Either<Failure, bool>> joinSession(int sessionId);
  Future<Either<Failure, bool>> deleteStaleSessions();
  Future<Either<Failure, bool>> clearActiveGroup();
  Future<Either<Failure, bool>> initializeSession(
    InitializeSessionParams params,
  );
  Future<Either<Failure, GroupEntity>> getGroup(int groupId);
}
