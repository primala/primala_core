import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:nokhte_backend/tables/session_information.dart';
import 'package:nokhte_backend/types/types.dart';

abstract class HomeContract {
  Future<Either<Failure, UserInformationEntity>> getUserInformation(
      NoParams params);

  Future<Either<Failure, Stream<List<CollaboratorRequests>>>>
      listenToCollaboratorRequests(
    NoParams params,
  );

  Future<Either<Failure, Stream<List<SessionRequests>>>>
      listenToSessionRequests(NoParams params);

  Future<Either<Failure, bool>> joinSession(String params);

  Future<Either<Failure, bool>> awakenSession(String params);

  Future<bool> cancelCollaboratorRequestsStream(
    NoParams params,
  );

  Future<Either<Failure, Stream<List<UserInformationEntity>>>>
      listenToCollaboratorRelationships(
    NoParams params,
  );

  Future<bool> cancelCollaboratorRelationshipsStream(
    NoParams params,
  );

  Future<Either<Failure, bool>> updateRequestStatus(
    UpdateRequestStatusParams params,
  );

  Future<Either<Failure, bool>> sendRequest(
    SendRequestParams params,
  );

  Future<Either<Failure, bool>> initializeSession(String groupUID);
}
