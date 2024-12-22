// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'needs_update_coordinator.g.dart';

class NeedsUpdateCoordinator = _NeedsUpdateCoordinatorBase
    with _$NeedsUpdateCoordinator;

abstract class _NeedsUpdateCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final NeedsUpdateWidgetsCoordinator widgets;
  @override
  final CaptureScreen captureScreen;

  _NeedsUpdateCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor() {
    widgets.constructor();
  }

  @action
  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
