// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
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

  @observable
  bool needsUpdate = false;

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
        beachWaves.setMovieMode(BeachWaveMovieModes.deepSeaToSky);
        Timer(Seconds.get(1), () {
          Modular.to.navigate(
            SessionConstants.lobby,
            arguments: {
              SessionConstants.isTheHost: true,
            },
          );
        });
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
      } else if (args == SessionConstants.information) {
        beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
        Timer(Seconds.get(1), () {
          Modular.to.navigate(SessionConstants.information);
        });
      } else if (args == SessionConstants.exit) {
        beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
        Timer(Seconds.get(1), () {
          Modular.to.navigate(SessionConstants.exit);
        });
      } else if (args == HomeConstants.home) {
        beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
        beachWaves.currentStore.initMovie(
          const AnyToOnShoreParams(
            startingColors: WaterColorsAndStops.onShoreWater,
            endValue: -5.0,
          ),
        );
      }
    }
    showBeachWaves = true;
    disposers.add(beachWavesMovieStatusReactor());
  }

  @action
  needsToUpdateConstructor() {
    needsUpdate = true;
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
          if (needsUpdate) {
            Modular.to.navigate(HomeConstants.needsToUpdate);
          } else {
            Modular.to.navigate(HomeConstants.home);
          }
        }
      });
}
