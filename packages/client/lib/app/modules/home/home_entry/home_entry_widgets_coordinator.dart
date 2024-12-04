// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'home_entry_widgets_coordinator.g.dart';

class HomeEntryWidgetsCoordinator = _HomeEntryWidgetsCoordinatorBase
    with _$HomeEntryWidgetsCoordinator;

abstract class _HomeEntryWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _HomeEntryWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
    beachWaves.currentStore.initMovie(
      const AnyToOnShoreParams(
        startingColors: WaterColorsAndStops.onShoreWater,
        endingColors: WaterColorsAndStops.onShoreWater,
      ),
    );
  }

  beachWavesMovieStatusReactor(Function onNavigationHome) =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          onNavigationHome();
        }
      });
}
