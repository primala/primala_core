// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/modules/p2p_collaborator_pool/domain/domain.dart';
part 'exit_collaborator_pool_getter_store.g.dart';

class ExitCollaboratorPoolGetterStore = _ExitCollaboratorPoolGetterStoreBase
    with _$ExitCollaboratorPoolGetterStore;

abstract class _ExitCollaboratorPoolGetterStoreBase extends Equatable
    with Store {
  final ExitCollaboratorPool exitPoolLogic;

  _ExitCollaboratorPoolGetterStoreBase({required this.exitPoolLogic});

  Future<Either<Failure, CollaboratorPoolExitStatusEntity>> call() async =>
      await exitPoolLogic(NoParams());

  @override
  List<Object> get props => [];
}
