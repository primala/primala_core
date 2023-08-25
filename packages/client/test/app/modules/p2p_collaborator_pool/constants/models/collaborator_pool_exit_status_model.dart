import 'package:dartz/dartz.dart';
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/data/models/models.dart';

class ConstantCollaboratorPoolExitStatusModel {
  static CollaboratorPoolExitStatusModel get successCase =>
      const CollaboratorPoolExitStatusModel(hasLeft: true);
  static CollaboratorPoolExitStatusModel get notSuccessCase =>
      const CollaboratorPoolExitStatusModel(hasLeft: false);
  static Either<Failure, CollaboratorPoolExitStatusModel>
      get wrappedSuccessCase =>
          const Right(CollaboratorPoolExitStatusModel(hasLeft: true));
  static Either<Failure, CollaboratorPoolExitStatusModel>
      get wrappedNotSuccessCase =>
          const Right(CollaboratorPoolExitStatusModel(hasLeft: false));
}
