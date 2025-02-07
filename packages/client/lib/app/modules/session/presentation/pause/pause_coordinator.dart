// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'pause_coordinator.g.dart';

class PauseCoordinator = _PauseCoordinatorBase with _$PauseCoordinator;

abstract class _PauseCoordinatorBase with Store, BaseWidgetsCoordinator {
  final TintStore tint;
  final SessionPresenceCoordinator presence;

  _PauseCoordinatorBase({
    required this.tint,
    required this.presence,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() async {
    await presence.dispose();
    Modular.dispose<SessionLogicModule>();
    await presence.listen();
    fadeInWidgets();
    tint.initMovie(const NoParams());
  }

  @action
  onTap() {
    if (!showWidgets) return;
    setShowWidgets(false);
    tint.reverseMovie(const NoParams());
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(SessionConstants.mainScreen);
    });
  }

  @action
  onSlideComplete() {
    if (!showWidgets) return;
    setShowWidgets(false);
    tint.reverseMovie(const NoParams());
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(SessionConstants.endSession);
    });
  }
}
