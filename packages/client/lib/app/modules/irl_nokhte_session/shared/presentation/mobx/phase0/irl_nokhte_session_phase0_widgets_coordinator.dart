// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'irl_nokhte_session_phase0_widgets_coordinator.g.dart';

class IrlNokhteSessionPhase0WidgetsCoordinator = _IrlNokhteSessionPhase0WidgetsCoordinatorBase
    with _$IrlNokhteSessionPhase0WidgetsCoordinator;

abstract class _IrlNokhteSessionPhase0WidgetsCoordinatorBase
    extends BaseWidgetsCoordinator with Store {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  final TouchRippleStore touchRipple;

  _IrlNokhteSessionPhase0WidgetsCoordinatorBase({
    required this.beachWaves,
    required super.wifiDisconnectOverlay,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.touchRipple,
  });

  @action
  constructor() {
    beachWaves.setMovieMode(
      BeachWaveMovieModes.vibrantBlueGradientToTimesUp,
    );
    primarySmartText.setMessagesData(
      MessagesData.irlNokhteSessionPhase0PrimaryList,
    );
    secondarySmartText.setMessagesData(
      MessagesData.irlNokhteSessionPhase0SecondaryList,
    );
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
  }

  @action
  invisiblizePrimarySmartText() => primarySmartText.setWidgetVisibility(false);

  @observable
  bool isFirstTap = true;

  @observable
  Stopwatch cooldownStopwatch = Stopwatch();

  @action
  onTap(
    Offset tapPosition, {
    required Function onFinalTap,
  }) async {
    touchRipple.onTap(tapPosition);
    if (isFirstTap) {
      cooldownStopwatch.start();
      primarySmartText.startRotatingText(isResuming: true);
      isFirstTap = false;
    } else if (!isFirstTap &&
        cooldownStopwatch.elapsedMilliseconds.isGreaterThan(950)) {
      primarySmartText.startRotatingText(isResuming: true);
      secondarySmartText.setWidgetVisibility(false);
      cooldownStopwatch.stop();
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
