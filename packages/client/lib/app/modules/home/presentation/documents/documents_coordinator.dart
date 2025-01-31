// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'documents_coordinator.g.dart';

class DocumentsCoordinator = _DocumentsCoordinatorBase
    with _$DocumentsCoordinator;

abstract class _DocumentsCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic {
  _DocumentsCoordinatorBase() {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
  }
}
