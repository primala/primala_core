// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:simple_animations/simple_animations.dart';
part 'session_group_greeter_widgets_coordinator.g.dart';

class SessionGroupGreeterWidgetsCoordinator = _SessionGroupGreeterWidgetsCoordinatorBase
    with _$SessionGroupGreeterWidgetsCoordinator;

abstract class _SessionGroupGreeterWidgetsCoordinatorBase
    extends BaseWidgetsCoordinator with Store {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  final TouchRippleStore touchRipple;
  final SessionSeatingGuideStore sessionSeatingGuide;
  final TintStore tint;

  _SessionGroupGreeterWidgetsCoordinatorBase({
    required this.beachWaves,
    required super.wifiDisconnectOverlay,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.touchRipple,
    required this.sessionSeatingGuide,
    required this.tint,
  });

  @action
  constructor({
    required int numberOfCollaborators,
    required int userIndex,
  }) {
    sessionSeatingGuide.setWidgetVisibility(false);
    beachWaves.setMovieMode(
      BeachWaveMovieModes.skyToDrySand,
    );
    primarySmartText.setMessagesData(
      SessionLists.getGroupGreeterPrimary(
        numberOfCollaborators: numberOfCollaborators,
        userIndex: userIndex,
      ),
    );
    sessionSeatingGuide.setValues(
      AdjacentNumbers.getAdjacentNumbers(
        numberOfCollaborators,
        userIndex + 1,
      ),
    );
    secondarySmartText.setMessagesData(SessionLists.groupGreeterSecondary);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
    beachWavesMovieStatusReactor();
  }

  @observable
  int tapCount = 0;

  @observable
  Stopwatch cooldownStopwatch = Stopwatch();

  @observable
  bool isTheLastOneToFinish = false;

  @observable
  bool hasTriggeredTint = false;

  @observable
  bool isGoingToHybridWaiting = false;

  @action
  setIsGoingToHybridWaiting(bool val) => isGoingToHybridWaiting = val;

  @action
  setIsTheLastOneToFinish(bool val) => isTheLastOneToFinish = val;

  @action
  invisiblizePrimarySmartText() => primarySmartText.setWidgetVisibility(false);

  @action
  onTap(
    Offset tapPosition, {
    required Function onFinalTap,
  }) async {
    if (tapCount == 0) {
      touchRipple.onTap(tapPosition);
      sessionSeatingGuide.setWidgetVisibility(true);
      cooldownStopwatch.start();
      primarySmartText.startRotatingText(isResuming: true);
      secondarySmartText.startRotatingText(isResuming: true);
      tapCount++;
    } else if (cooldownStopwatch.elapsedMilliseconds.isGreaterThan(950)) {
      if (tapCount == 1) {
        cooldownStopwatch.reset();
        touchRipple.onTap(tapPosition);
        primarySmartText.startRotatingText(isResuming: true);
        secondarySmartText.startRotatingText(isResuming: true);
        tapCount++;
      } else if (tapCount == 2) {
        touchRipple.onTap(tapPosition);
        primarySmartText.startRotatingText(isResuming: true);
        secondarySmartText.startRotatingText(isResuming: true);
        cooldownStopwatch.stop();
        sessionSeatingGuide.setWidgetVisibility(false);
        tapCount++;
        await onFinalTap();
      }
    }
  }

  @action
  initTransitionToSpeaking() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    beachWaves.currentStore.initMovie(NoParams());
  }

  @action
  initTransitionToHybrid() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToInvertedHalfAndHalf);
    beachWaves.currentStore.initMovie(NoParams());
  }

  @action
  onCollaboratorLeft() {
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
    tint.setWidgetVisibility(false);
    sessionSeatingGuide.setWidgetVisibility(false);
  }

  @action
  onCollaboratorJoined() {
    primarySmartText.setWidgetVisibility(primarySmartText.pastShowWidget);
    secondarySmartText.setWidgetVisibility(secondarySmartText.pastShowWidget);
    tint.setWidgetVisibility(tint.pastShowWidget);
    sessionSeatingGuide.setWidgetVisibility(sessionSeatingGuide.pastShowWidget);
  }

  @action
  initTransition(String route) {
    if (hasTriggeredTint) {
      tint.setControl(Control.playReverse);
      primarySmartText.setWidgetVisibility(false);
    }
    Timer(Seconds.get(2), () {
      if (route == SessionConstants.speaking) {
        initTransitionToSpeaking();
      } else if (route == SessionConstants.hybrid) {
        initTransitionToHybrid();
      } else {
        Modular.to.navigate(route);
      }
    });
  }

  primarySmartTextIndexReactor({
    required Function initTransition,
    required Function onComplete,
  }) =>
      reaction((p0) => primarySmartText.currentIndex, (p0) async {
        if (p0 == 3) {
          await onComplete();
          if (isTheLastOneToFinish) {
            initTransition();
          } else {
            Timer(Seconds.get(0, milli: 500), () {
              primarySmartText.startRotatingText(isResuming: true);
            });
            tint.setControl(Control.play);
            hasTriggeredTint = true;
          }
        }
      });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.skyToHalfAndHalf) {
            Modular.to.navigate(SessionConstants.speaking);
          } else {
            if (isGoingToHybridWaiting) {
              Modular.to.navigate(SessionConstants.hybridWaiting);
            } else {
              Modular.to.navigate(SessionConstants.hybrid);
            }
          }
        }
      });
}
