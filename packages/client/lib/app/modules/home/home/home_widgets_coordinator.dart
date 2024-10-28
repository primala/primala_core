// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/constants/constants.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:simple_animations/simple_animations.dart';
part 'home_widgets_coordinator.g.dart';

class HomeWidgetsCoordinator = _HomeWidgetsCoordinatorBase
    with _$HomeWidgetsCoordinator;

abstract class _HomeWidgetsCoordinatorBase
    with
        Store,
        EnRoute,
        Reactions,
        EnRouteConsumer,
        EnRouteWidgetsRouter,
        SwipeNavigationUtils,
        NokhteWidgetsUtils,
        SmartTextPaddingAdjuster,
        BaseWidgetsCoordinator {
  AuxiliaryNokhteStore sessionStarterNokhte;
  AuxiliaryNokhteStore storageNokhte;
  AuxiliaryNokhteStore sessionJoinerNokhte;
  AuxiliaryNokhteStore deactivateNokhte;
  SwipeGuideStore swipeGuides;
  final NokhteBlurStore nokhteBlur;
  final GestureCrossStore gestureCross;
  final SmartTextStore smartText;
  final SmartTextStore gestureCrossSmartText;
  @override
  final CenterNokhteStore centerNokhte;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  @override
  final List<AuxiliaryNokhteStore> auxNokhtes;

  _HomeWidgetsCoordinatorBase({
    required this.nokhteBlur,
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
    required this.gestureCross,
    required this.smartText,
    required this.gestureCrossSmartText,
    required this.centerNokhte,
    required this.swipeGuides,
    required this.sessionStarterNokhte,
    required this.deactivateNokhte,
    required this.sessionJoinerNokhte,
    required this.storageNokhte,
  }) : auxNokhtes = [
          sessionStarterNokhte,
          storageNokhte,
          sessionJoinerNokhte,
          deactivateNokhte,
        ] {
    initEnRouteActions();
    initSwipeNavigationUtils();
    initNokhteWidgetsUtils();
    initSmartTextActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    consumeRoutingArgs();
    gestureCross.fadeInTheCross();
    swipeGuides.setWidgetVisibility(false);
    centerNokhte.fadeIn();
    sessionStarterNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.top,
      AuxiliaryNokhteColorways.invertedBeachWave,
    );
    deactivateNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.left,
      AuxiliaryNokhteColorways.deeperBlue,
    );
    sessionJoinerNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.bottom,
      AuxiliaryNokhteColorways.orangeSand,
    );
    storageNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.right,
      AuxiliaryNokhteColorways.vibrantBlue,
    );
    smartText.setMessagesData(HomeList.list);

    gestureCrossSmartText.setWidgetVisibility(false);
    gestureCrossSmartText.setMessagesData(HomeList.gestureCrossList);
    gestureCrossSmartText.startRotatingText();
    smartText.startRotatingText();
    initReactors();
    setupEnRouteWidgets();
  }

  @action
  onSwipeUp() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.up);
        nokhteBlur.reverse();
        gestureCrossSmartText.setWidgetVisibility(false);
        centerNokhte.initMovie(AuxiliaryNokhtePositions.top);
        sessionJoinerNokhte.disappear();
        deactivateNokhte.disappear();
        storageNokhte.disappear();
        smartText.setWidgetVisibility(false);
        setSwipeGuideVisibilities(false);
      }
    }
  }

  @action
  onSwipeLeft() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.left);
        nokhteBlur.reverse();
        centerNokhte.initMovie(AuxiliaryNokhtePositions.left);
        sessionJoinerNokhte.disappear();
        sessionStarterNokhte.disappear();
        storageNokhte.disappear();
        smartText.setWidgetVisibility(false);
        setSwipeGuideVisibilities(false);
      }
    }
  }

  onSwipeDown() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.down);
        centerNokhte.initMovie(AuxiliaryNokhtePositions.bottom);
        deactivateNokhte.disappear();
        sessionStarterNokhte.disappear();
        storageNokhte.disappear();
        smartText.setWidgetVisibility(false);
        setSwipeGuideVisibilities(false);
      }
    }
  }

  @action
  initSoloSession() {
    if (hasInitiatedBlur) return;
    gestureCross.fadeAllOut();
    for (var element in auxNokhtes) {
      element.setWidgetVisibility(false);
    }
    centerNokhte.setWidgetVisibility(false);
    smartText.setWidgetVisibility(false);
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
    beachWaves.currentStore.reverseMovie(
      AnyToOnShoreParams(
        startingColors: WaterColorsAndStops.halfWaterAndSand,
        endingColors: WaterColorsAndStops.onShoreWater,
        endValue: beachWaves.currentAnimationValues.first,
      ),
    );
  }

  @action
  onSwipeRight() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.down);
        smartText.setWidgetVisibility(false);
        centerNokhte.initMovie(AuxiliaryNokhtePositions.right);
        sessionStarterNokhte.disappear();
        deactivateNokhte.disappear();
        sessionJoinerNokhte.disappear();
        setSwipeGuideVisibilities(false);
      }
    }
  }

  @action
  initReactors() {
    disposers.add(deactivateNokhteReactor());
    disposers.add(smartTextIndexReactor());
    disposers.add(gestureCrossTapReactor());
    disposers.add(sessionJoinerNokhteReactor());
    disposers.add(centerNokhteReactor());
    disposers.add(storageNokhteReactor());
    disposers.add(sessionStarterNokhteReactor());
  }

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );

  sessionJoinerNokhteReactor() =>
      reaction((p0) => sessionJoinerNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            sessionJoinerNokhte.movieMode ==
                AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(SessionJoinerConstants.sessionJoiner);
        }
      });

  sessionStarterNokhteReactor() =>
      reaction((p0) => sessionStarterNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            sessionStarterNokhte.movieMode ==
                AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(SessionStarterConstants.sessionStarterEntry);
        }
      });

  storageNokhteReactor() => reaction((p0) => storageNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            storageNokhte.movieMode == AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(StorageConstants.home);
        }
      });
  deactivateNokhteReactor() =>
      reaction((p0) => deactivateNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            deactivateNokhte.movieMode == AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(SettingsConstants.settings);
        }
      });

  centerNokhteReactor() => reaction(
        (p0) => centerNokhte.movieStatus,
        (p0) {
          if (p0 == MovieStatus.finished &&
              centerNokhte.movieMode == CenterNokhteMovieModes.moveAround) {
            if (centerNokhte.position == AuxiliaryNokhtePositions.bottom) {
              sessionJoinerNokhte.explode();
            } else if (centerNokhte.position ==
                AuxiliaryNokhtePositions.right) {
              storageNokhte.explode();
            } else if (centerNokhte.position == AuxiliaryNokhtePositions.top) {
              sessionStarterNokhte.explode();
            } else if (centerNokhte.position == AuxiliaryNokhtePositions.left) {
              deactivateNokhte.explode();
            }
          }
        },
      );

  @override
  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (beachWaves.movieStatus == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
            Modular.to.navigate(SessionConstants.polymorphicSolo);
          } else {
            beachWaves.setMovieStatus(MovieStatus.inProgress);
            if (waterDirecton == WaterDirection.up) {
              beachWaves.currentStore.setControl(Control.playFromStart);
              setWaterDirection(WaterDirection.down);
            } else {
              beachWaves.currentStore.setControl(Control.playReverseFromEnd);
              setWaterDirection(WaterDirection.up);
            }
          }
        }
      });

  @action
  onGestureCrossTap() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (!hasInitiatedBlur) {
        setHasInitiatedBlur(true);

        nokhteBlur.init();
        beachWaves.currentStore.setControl(Control.stop);
        smartText.setWidgetVisibility(false);

        gestureCrossSmartText.setWidgetVisibility(true);
        centerNokhte.moveToCenter();
        Timer(const Duration(seconds: 0, milliseconds: 500), () {
          setSmartTextTopPaddingScalar(.6);
        });
        swipeGuides.fadeIn();
        sessionStarterNokhte.setWidgetVisibility(true);
        storageNokhte.setWidgetVisibility(true);
        moveAuxNokhtes(shouldExpand: true);
      } else if (hasInitiatedBlur && !hasSwiped()) {
        dismissNokhte();
      }
    }
  }

  smartTextIndexReactor() => reaction((p0) => smartText.currentIndex, (p0) {
        if (p0 == 2) {
          Timer.periodic(const Duration(seconds: 1), (timer) {
            if (smartText.showWidget) {
              smartText.reset();
              timer.cancel();
            }
          });
        }
      });

  @action
  dismissNokhte() {
    setSwipeGuideVisibilities(false);
    smartText.reset();
    setHasInitiatedBlur(false);
    gestureCrossSmartText.setWidgetVisibility(false);
    setSwipeDirection(GestureDirections.initial);
    centerNokhte.moveBackToCross();
    moveAuxNokhtes(shouldExpand: false);
    nokhteBlur.reverse();
    beachWaves.currentStore.setControl(Control.mirror);
    delayedEnableTouchFeedback();
  }

  setSwipeGuideVisibilities(bool shouldShow) {
    swipeGuides.setWidgetVisibility(shouldShow);
  }

  moveAuxNokhtes({required bool shouldExpand}) {
    final dir =
        shouldExpand ? NokhteScaleState.enlarge : NokhteScaleState.shrink;
    deactivateNokhte.initMovie(dir);
    sessionStarterNokhte.initMovie(dir);
    sessionJoinerNokhte.initMovie(dir);
    storageNokhte.initMovie(dir);
  }
}
