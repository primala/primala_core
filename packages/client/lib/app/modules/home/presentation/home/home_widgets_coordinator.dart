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
        SwipeNavigationUtils,
        EnRouteWidgetsRouter,
        BaseWidgetsCoordinator {
  SwipeGuideStore swipeGuides;
  final NavigationCarouselsStore navigationCarousels;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _HomeWidgetsCoordinatorBase({
    required this.navigationCarousels,
    required this.wifiDisconnectOverlay,
    required this.swipeGuides,
  }) : beachWaves = navigationCarousels.beachWaves {
    initEnRouteActions();
    initSwipeNavigationUtils();

    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    navigationCarousels
        .setNavigationCarouselsType(NavigationCarouselsType.homescreen);
    beachWaves.setMovieMode(BeachWaveMovieModes.onShore);
    consumeRoutingArgs();
    swipeGuides.setWidgetVisibility(false);
    setupEnRouteWidgets();
    disposers.add(beachWavesMovieStatusReactor());
  }

  @action
  initSoloSession() async {
    if (hasSwiped()) return;
    setSwipeDirection(GestureDirections.up);
    navigationCarousels.setWidgetVisibility(false);
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
    beachWaves.currentStore.reverseMovie(
      AnyToOnShoreParams(
        startingColors: WaterColorsAndStops.halfWaterAndSand,
        endingColors: WaterColorsAndStops.onShoreWater,
        endValue: beachWaves.currentAnimationValues.first,
      ),
    );
  }

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
}
