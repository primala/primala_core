// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_duo_greeter_widgets_coordinator.g.dart';

class SessionDuoGreeterWidgetsCoordinator = _SessionDuoGreeterWidgetsCoordinatorBase
    with _$SessionDuoGreeterWidgetsCoordinator;

abstract class _SessionDuoGreeterWidgetsCoordinatorBase
    with Store, SessionRouter, BaseWidgetsCoordinator {
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  final TouchRippleStore touchRipple;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionDuoGreeterWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.touchRipple,
  }) {
    initBaseWidgetsCoordinatorActions();
  }
  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
    primarySmartText.setMessagesData(SessionLists.duoGreeterPrimary);
    secondarySmartText.setMessagesData(SessionLists.duoGreeterSecondary);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
  }

  @action
  hidePrimarySmartText() => primarySmartText.setWidgetVisibility(false);

  @observable
  bool isFirstTap = true;

  @observable
  bool hasCompletedInstructions = false;

  @observable
  Stopwatch cooldownStopwatch = Stopwatch();

  @action
  onTap(
    Offset tapPosition, {
    required Function onFinalTap,
    required SessionScreenTypes phoneType,
  }) async {
    if (isFirstTap) {
      touchRipple.onTap(tapPosition);
      cooldownStopwatch.start();
      primarySmartText.startRotatingText(isResuming: true);
      secondarySmartText.startRotatingText(isResuming: true);
      isFirstTap = false;
    } else if (!isFirstTap &&
        cooldownStopwatch.elapsedMilliseconds.isGreaterThan(950)) {
      touchRipple.onTap(tapPosition);
      primarySmartText.startRotatingText(isResuming: true);
      secondarySmartText.startRotatingText(isResuming: true);
      cooldownStopwatch.reset();
      cooldownStopwatch.stop();
      hasCompletedInstructions = true;
      initTransition(phoneType);
      await onFinalTap();
    }
  }

  @action
  onTenSecondLapse() {
    primarySmartText.startRotatingText(isResuming: true);
  }

  @action
  onCollaboratorLeft() {
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
  }

  @action
  onCollaboratorJoined() {
    primarySmartText.setWidgetVisibility(primarySmartText.pastShowWidget);
    secondarySmartText.setWidgetVisibility(secondarySmartText.pastShowWidget);
  }
}
