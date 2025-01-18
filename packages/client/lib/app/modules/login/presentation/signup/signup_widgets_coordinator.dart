// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
part 'signup_widgets_coordinator.g.dart';

class SignupWidgetsCoordinator = _SignupWidgetsCoordinatorBase
    with _$SignupWidgetsCoordinator;

abstract class _SignupWidgetsCoordinatorBase
    with Store, SmartTextPaddingAdjuster, BaseWidgetsCoordinator, Reactions {
  final AnimatedScaffoldStore animatedScaffold;
  final BackButtonStore backButton;
  final AuthTextFieldsStore authTextFields;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SignupWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.authTextFields,
    required this.backButton,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  initFadein() {
    authTextFields.setFieldsToShow([
      FieldsToShow.fullName,
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
    //
  }

  animatedScaffoldReactor(Function onComplete) =>
      reaction((p0) => animatedScaffold.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          onComplete();
        }
      });
}
