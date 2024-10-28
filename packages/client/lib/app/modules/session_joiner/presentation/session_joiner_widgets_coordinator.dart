// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/constants/constants.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
part 'session_joiner_widgets_coordinator.g.dart';

class SessionJoinerWidgetsCoordinator = _SessionJoinerWidgetsCoordinatorBase
    with _$SessionJoinerWidgetsCoordinator;

abstract class _SessionJoinerWidgetsCoordinatorBase
    with
        Store,
        BaseWidgetsCoordinator,
        Reactions,
        SwipeNavigationUtils,
        NokhteWidgetsUtils,
        HomeNavigation {
  final GestureCrossStore gestureCross;
  final QrScannerStore qrScanner;
  final BeachWavesStore beachWaves;
  @override
  final CenterNokhteStore centerNokhte;
  @override
  final AuxiliaryNokhteStore homeNokhte;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  @override
  final SwipeGuideStore swipeGuide;
  @override
  final List<AuxiliaryNokhteStore> auxNokhtes;

  _SessionJoinerWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.gestureCross,
    required this.qrScanner,
    required this.wifiDisconnectOverlay,
    required this.centerNokhte,
    required this.homeNokhte,
    required this.swipeGuide,
  }) : auxNokhtes = [homeNokhte] {
    initSwipeNavigationUtils();
    initBaseWidgetsCoordinatorActions();
    initNokhteWidgetsUtils();
  }

  @action
  constructor() {
    gestureCross.cross.initStaticGlow();
    centerNokhte.setWidgetVisibility(false);
    beachWaves.setMovieMode(BeachWaveMovieModes.emptyTheOcean);
    initReactors();
  }

  initReactors() {
    disposers.add(qrScannerReactor());
    disposers.add(gestureCrossTapReactor());
    disposers.add(beachWavesReactor());
    initHomeNavigationReactions();
  }

  @action
  enterSession() {
    beachWaves.setMovieMode(BeachWaveMovieModes.emptyOceanToInvertedDeepSea);
    beachWaves.currentStore.initMovie(const NoParams());
    gestureCross.fadeAllOut();
    centerNokhte.setWidgetVisibility(false);
    homeNokhte.setWidgetVisibility(false);
    qrScanner.fadeOut();
  }

  @action
  onTap() {
    if (hasInitiatedBlur && isAllowedToMakeGesture()) {
      dismissNokhtes();
    }
  }

  @action
  onSwipeUp() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur && !hasSwiped()) {
        setSwipeDirection(GestureDirections.up);
        centerNokhte.initMovie(AuxiliaryNokhtePositions.top);
        swipeGuide.setWidgetVisibility(false);
      }
    }
  }

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );

  @action
  onGestureCrossTap() {
    if (!isDisconnected && isAllowedToMakeGesture() && !hasSwiped()) {
      if (!hasInitiatedBlur) {
        swipeGuide.fadeIn();
        centerNokhte.moveToCenter();
        setHasInitiatedBlur(true);
        qrScanner.fadeOut();
        homeNokhte.setWidgetVisibility(true);
        moveSessionStarterNokhte(true);
      } else {
        swipeGuide.setWidgetVisibility(false);
        dismissNokhtes();
      }
    }
  }

  dismissNokhtes() {
    if (hasInitiatedBlur) {
      setHasInitiatedBlur(false);
      qrScanner.fadeIn();
      moveSessionStarterNokhte(false);
      centerNokhte.moveBackToCross();
      setSwipeDirection(GestureDirections.initial);
    }
  }

  moveSessionStarterNokhte(bool shouldExpand) {
    homeNokhte.initMovie(
      shouldExpand ? NokhteScaleState.enlarge : NokhteScaleState.shrink,
    );
  }

  beachWavesReactor() => reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          Modular.to.navigate(SessionConstants.lobby);
        }
      });

  qrScannerReactor() => reaction((p0) => qrScanner.showWidget, (p0) {
        if (p0) {
          if (!gestureCross.cross.showWidget) {
            gestureCross.fadeInTheCross();
            centerNokhte.fadeIn();
            homeNokhte.setAndFadeIn(
              AuxiliaryNokhtePositions.top,
              AuxiliaryNokhteColorways.beachWave,
            );
          }
          beachWaves.currentStore.setWidgetVisibility(false);
        } else {
          beachWaves.currentStore.setWidgetVisibility(true);
        }
      });
}
