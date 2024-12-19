import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';

abstract class HomeContract {
  String getUserUID(NoParams params);

  Future<Either<Failure, Stream<List<CollaboratorRequests>>>>
      listenToCollaboratorRequests(
    NoParams params,
  );

  Future<bool> cancelCollaboratorRequestsStream(
    NoParams params,
  );

  Future<Either<Failure, Stream<List<CollaboratorRelationshipEntity>>>>
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
}
