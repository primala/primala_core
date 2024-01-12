// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_coordinator.dart';
import 'purpose_session_phase_one_widgets_coordinator.dart';
part 'purpose_session_phase_one_coordinator.g.dart';

class PurposeSessionPhaseOneCoordinator = _PurposeSessionPhaseOneCoordinatorBase
    with _$PurposeSessionPhaseOneCoordinator;

abstract class _PurposeSessionPhaseOneCoordinatorBase extends BaseCoordinator
    with Store {
  final PurposeSessionPhaseOneWidgetsCoordinator widgets;

  _PurposeSessionPhaseOneCoordinatorBase({
    required this.widgets,
  });

  @action
  constructor() {
    widgets.constructor();
  }
}
