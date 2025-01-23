import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';

mixin BaseCoordinator {
  CaptureScreen get captureScreen;

  final _disableAllTouchFeedback = Observable(false);
  bool get disableAllTouchFeedback => _disableAllTouchFeedback.value;

  Action actionToggleDisableAllTouchFeedback = Action(() {});
  Action actionSetDisableAllTouchFeedback = Action(() {});

  initBaseCoordinatorActions() {
    actionToggleDisableAllTouchFeedback =
        Action(_toggleDisableAllTouchFeedback);
    actionSetDisableAllTouchFeedback = Action(_setDisableAllTouchFeedback);
  }

  _toggleDisableAllTouchFeedback() =>
      _disableAllTouchFeedback.value = _disableAllTouchFeedback.value;

  _setDisableAllTouchFeedback(bool value) =>
      _disableAllTouchFeedback.value = value;

  toggleDisableAllTouchFeedback() {
    actionToggleDisableAllTouchFeedback.call();
  }

  setDisableAllTouchFeedback(bool value) {
    actionSetDisableAllTouchFeedback.call([value]);
  }

  ifTouchIsNotDisabled(Function callback) async {
    if (!disableAllTouchFeedback) await callback();
  }

  @action
  onAppLifeCycleStateChange(
    p0, {
    required Function onResumed,
    required Function onInactive,
    Function? onDetached,
  }) {
    switch (p0) {
      case AppLifecycleState.resumed:
        onResumed();
      case AppLifecycleState.inactive:
        onInactive();
      case AppLifecycleState.detached:
        onDetached?.call();
      default:
        break;
    }
  }
}
