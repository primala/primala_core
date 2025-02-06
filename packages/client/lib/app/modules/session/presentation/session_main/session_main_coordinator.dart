// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
part 'session_main_coordinator.g.dart';

class SessionMainCoordinator = _SessionMainCoordinatorBase
    with _$SessionMainCoordinator;

abstract class _SessionMainCoordinatorBase
    with Store, BaseCoordinator, BaseWidgetsCoordinator, Reactions {
  @override
  final CaptureScreen captureScreen;

  _SessionMainCoordinatorBase({
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {}
  //
}
