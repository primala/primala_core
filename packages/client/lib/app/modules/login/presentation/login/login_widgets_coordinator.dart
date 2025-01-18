// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import 'package:simple_animations/simple_animations.dart';
part 'login_widgets_coordinator.g.dart';

class LoginWidgetsCoordinator = _LoginWidgetsCoordinatorBase
    with _$LoginWidgetsCoordinator;

abstract class _LoginWidgetsCoordinatorBase
    with Store, SmartTextPaddingAdjuster, BaseWidgetsCoordinator, Reactions {
  final AnimatedScaffoldStore animatedScaffold;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final AuthTextFieldsStore authTextFields;
  final BackButtonStore backButton;

  _LoginWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.wifiDisconnectOverlay,
    required this.backButton,
    required this.authTextFields,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
  }

  @action
  initFadein() {
    authTextFields.setFieldsToShow([
      FieldsToShow.email,
      FieldsToShow.password,
    ]);
    setShowWidgets(false);
    Timer(Seconds.get(0, milli: 1), () {
      setShowWidgets(true);
    });
  }

  @observable
  bool showWidgets = true;

  @action
  setShowWidgets(bool value) {
    backButton.setWidgetVisibility(value);
    showWidgets = value;
  }

  @action
  loggedInOnResumed() {
    animatedScaffold.setControl(Control.play);
  }

  animatedScaffoldReactor(Function onComplete) =>
      reaction((p0) => animatedScaffold.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          onComplete();
        }
      });
}
