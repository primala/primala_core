// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'docs_hub_coordinator.g.dart';

class DocsHubCoordinator = _DocsHubCoordinatorBase with _$DocsHubCoordinator;

abstract class _DocsHubCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic {
  _DocsHubCoordinatorBase() {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
  }
}
