// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
import 'package:nokhte/app/modules/session_starters/constants/constants.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:simple_animations/simple_animations.dart';
part 'quick_actions_router_widgets_coordinator.g.dart';

class QuickActionsRouterWidgetsCoordinator = _QuickActionsRouterWidgetsCoordinatorBase
    with _$QuickActionsRouterWidgetsCoordinator;

abstract class _QuickActionsRouterWidgetsCoordinatorBase
    with Store, RoutingArgs, Reactions {
  final BeachWavesStore beachWaves;

  _QuickActionsRouterWidgetsCoordinatorBase({
    required this.beachWaves,
  });

  @observable
  bool showBeachWaves = false;

  @observable
  bool shouldRotate = false;

  @action
  setShowBeachWaves(bool value) => showBeachWaves = value;

  @action
  preconstructor() {
    beachWaves.currentStore.setControl(Control.stop);
  }

  @action
  constructor() {
    if (hasReceivedRoutingArgs) {
      final args = Modular.args.data[HomeConstants.QUICK_ACTIONS_ROUTE];
      if (args == SessionStarterConstants.sessionStarter) {
        shouldRotate = true;
        beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
        beachWaves.currentStore.initMovie(
          const AnyToOnShoreParams(
            startingColors: WaterColorsAndStops.simpleInvertedBeachWater,
            endingColors: WaterColorsAndStops.invertedBeachWater,
            endValue: -5.0,
          ),
        );
      } else if (args == SessionJoinerConstants.sessionJoiner) {
        shouldRotate = true;
        beachWaves.setMovieMode(BeachWaveMovieModes.emptyTheOcean);
        Timer(Seconds.get(1), () {
          Modular.to.navigate(SessionJoinerConstants.sessionJoiner);
        });
      } else if (args == StorageConstants.home) {
        beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
        Timer(Seconds.get(1), () {
          Modular.to.navigate(StorageConstants.home);
        });
      }
    }
    showBeachWaves = true;
    disposers.add(beachWavesMovieStatusReactor());
  }

  @action
  needsToUpdateConstructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
    beachWaves.currentStore.initMovie(
      const AnyToOnShoreParams(
        startingColors: WaterColorsAndStops.onShoreWater,
        endingColors: WaterColorsAndStops.onShoreWater,
        endValue: -5.0,
      ),
    );
    showBeachWaves = true;
    disposers.add(beachWavesMovieStatusReactor());
  }

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (shouldRotate) {
            Modular.to.navigate(SessionStarterConstants.sessionStarter);
          } else {
            Modular.to.navigate(HomeConstants.needsToUpdate);
          }
        }
      });
}
