// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'home_coordinator.g.dart';

class HomeCoordinator = _HomeCoordinatorBase with _$HomeCoordinator;

abstract class _HomeCoordinatorBase
    with Store, BaseCoordinator, BaseMobxLogic, Reactions {
  final HomeWidgetsCoordinator widgets;
  final TapDetector tap;
  @override
  final CaptureScreen captureScreen;

  _HomeCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await captureScreen(HomeConstants.home);
  }

  initReactors() {
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () {
        widgets.setIsDisconnected(false);
        setDisableAllTouchFeedback(false);
      },
      onLongReConnected: () {
        widgets.setIsDisconnected(false);
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        widgets.setIsDisconnected(true);
      },
    ));
    disposers.add(tapReactor());
  }

  tapReactor() => reaction((p0) => tap.doubleTapCount, (p0) {
        widgets.initSoloSession();
      });

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
