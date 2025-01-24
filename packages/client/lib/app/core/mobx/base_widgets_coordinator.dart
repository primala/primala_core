// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';

mixin BaseWidgetsCoordinator {
  final _showWidgets = Observable(false);

  bool get showWidgets => _showWidgets.value;

  _setShowWidgets(bool value) => _showWidgets.value = value;

  Action actionSetShowWidgets = Action(() {});

  setShowWidgets(bool value) {
    actionSetShowWidgets([value]);
  }

  initBaseWidgetsCoordinatorActions() {
    actionSetShowWidgets = Action(_setShowWidgets);
  }

  fadeInWidgets() {
    setShowWidgets(false);
    Timer(Seconds.get(1), () {
      setShowWidgets(true);
    });
  }
}
