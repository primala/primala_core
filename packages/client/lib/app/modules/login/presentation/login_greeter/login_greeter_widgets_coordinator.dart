// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'login_greeter_widgets_coordinator.g.dart';

class LoginGreeterWidgetsCoordinator = _LoginGreeterWidgetsCoordinatorBase
    with _$LoginGreeterWidgetsCoordinator;

abstract class _LoginGreeterWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, AnimatedScaffoldMovie {
  final AnimatedScaffoldStore animatedScaffold;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _LoginGreeterWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  bool showWidgets = true;

  @action
  setShowWidgets(bool value) => showWidgets = value;

  @action
  initFadein() {
    setShowWidgets(false);
    Timer(Seconds.get(0, milli: 1), () {
      setShowWidgets(true);
    });
  }

  @action
  loggedInOnResumed() {
    setShowWidgets(false);
    animatedScaffold.setMovie(getMovie(Colors.black, const Color(0xFFFFFBEC)));
    animatedScaffold.setControl(Control.playFromStart);
  }

  animatedScaffoldReactor(Function onComplete) =>
      reaction((p0) => animatedScaffold.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          onComplete();
        }
      });
}
