// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'login_widgets_coordinator.g.dart';

class LoginScreenWidgetsCoordinator = _LoginScreenWidgetsCoordinatorBase
    with _$LoginScreenWidgetsCoordinator;

abstract class _LoginScreenWidgetsCoordinatorBase
    with Store, SmartTextPaddingAdjuster, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore layer1BeachWaves;
  final BeachWavesStore layer2BeachWaves;
  final SmartTextStore smartTextStore;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _LoginScreenWidgetsCoordinatorBase({
    required this.layer1BeachWaves,
    required this.layer2BeachWaves,
    required this.smartTextStore,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
  }

  constructor(
    Function onConnected,
    Function onDisconnected,
  ) {
    layer1BeachWaves.setMovieMode(BeachWaveMovieModes.blackOutToDrySand);
    layer2BeachWaves.currentStore.setWidgetVisibility(false);
    smartTextStore.setMessagesData(LoginList.list);
    smartTextStore.startRotatingText();
    initReactors();
    setSmartTextSubMessagePaddingScalar(200);
  }

  @observable
  bool canSwipeUp = false;

  @observable
  bool hasCompletedSandTransition = false;

  @observable
  bool hasCompletedWaterFromTopToOnShorePt1 = false;

  @observable
  bool hasCompletedWaterFromTopToOnShorePt2 = false;

  @observable
  bool hasTriggeredLoginAnimation = false;

  @observable
  bool showLoginButtons = false;

  @action
  toggleHasCompletedSandTransition() =>
      hasCompletedSandTransition = !hasCompletedSandTransition;

  @action
  toggleHasCompletedWaterFromTopToOnShorePt1() =>
      hasCompletedWaterFromTopToOnShorePt1 =
          !hasCompletedWaterFromTopToOnShorePt1;
  @action
  toggleHasCompletedWaterFromTopToOnShorePt2() =>
      hasCompletedWaterFromTopToOnShorePt2 =
          !hasCompletedWaterFromTopToOnShorePt2;

  @action
  toggleHasTriggeredLoginAnimation() =>
      hasTriggeredLoginAnimation = !hasTriggeredLoginAnimation;

  @action
  setCanSwipeUp(bool newBool) => canSwipeUp = newBool;

  @action
  onLongReConnected() {
    smartTextStore.reset();
    smartTextStore.startRotatingText();
  }

  @action
  onTap() {
    if (!showLoginButtons && smartTextStore.currentIndex == 1) {
      smartTextStore.startRotatingText(isResuming: true);
      showLoginButtons = true;
    }
  }

  @action
  onSwipeUp() {
    if (canSwipeUp) {
      setCanSwipeUp(false);
    }
  }

  @action
  triggerLoginAnimation() {
    smartTextStore.setWidgetVisibility(false);
    showLoginButtons = false;
    toggleHasTriggeredLoginAnimation();
    Timer(Seconds.get(0, milli: 500), () {
      layer1BeachWaves.setMovieMode(BeachWaveMovieModes.blackOutToDrySand);
      layer1BeachWaves.currentStore.initMovie(const NoParams());
    });
  }

  @action
  loggedInOnResumed() {
    if (!hasTriggeredLoginAnimation) {
      triggerLoginAnimation();
    } else if (!hasCompletedSandTransition) {
      layer1BeachWaves.currentStore.setControl(Control.play);
    } else if (!hasCompletedWaterFromTopToOnShorePt1 ||
        !hasCompletedWaterFromTopToOnShorePt2) {
      layer2BeachWaves.currentStore.setControl(Control.play);
    }
  }

  initReactors() {
    // disposers.add(nokhteReactor(loginBusinessLogic));
    disposers.add(layer1BeachWavesReactor());
  }

  layer1BeachWavesReactor() =>
      reaction((p0) => layer1BeachWaves.movieStatus, (p0) {
        if (hasFinishedBlackOutToSand(p0)) {
          toggleHasCompletedSandTransition();
          layer2BeachWaves.setMovieMode(
            BeachWaveMovieModes.waterFromTopToOnShorePt1,
          );
          layer2BeachWaves.currentStore.initMovie(const NoParams());
        }
      });

  layer2BeachWavesReactor(Function onPt2Finished) =>
      reaction((p0) => layer2BeachWaves.movieStatus, (p0) {
        if (hasFinishedWaterFromTopPart1(p0)) {
          layer2BeachWaves.setMovieMode(
            BeachWaveMovieModes.waterFromTopToOnShorePt2,
          );
          layer2BeachWaves.currentStore.initMovie(const NoParams());
          toggleHasCompletedWaterFromTopToOnShorePt1();
          layer2BeachWaves.currentStore.initMovie(const NoParams());
        } else if (hasFinishedWaterFromTopPart2(p0)) {
          onPt2Finished();
        }
      });

  hasFinishedBlackOutToSand(MovieStatus movieStatus) =>
      movieStatus == MovieStatus.finished &&
      layer1BeachWaves.movieMode == BeachWaveMovieModes.blackOutToDrySand;

  hasFinishedWaterFromTopPart2(MovieStatus movieStatus) =>
      movieStatus == MovieStatus.finished &&
      layer2BeachWaves.movieMode ==
          BeachWaveMovieModes.waterFromTopToOnShorePt2 &&
      hasCompletedWaterFromTopToOnShorePt1;

  hasFinishedWaterFromTopPart1(MovieStatus movieStatus) =>
      movieStatus == MovieStatus.finished &&
      layer2BeachWaves.movieMode ==
          BeachWaveMovieModes.waterFromTopToOnShorePt1 &&
      hasCompletedSandTransition;
}
