// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'information_coordinator.g.dart';

class InformationCoordinator = _InformationCoordinatorBase
    with _$InformationCoordinator;

abstract class _InformationCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic {
  _InformationCoordinatorBase() {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }
}
