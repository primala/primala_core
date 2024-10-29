// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'session_refresh_widgets_coordinator.g.dart';

class SessionRefreshWidgetsCoordinator = _SessionRefreshWidgetsCoordinatorBase
    with _$SessionRefreshWidgetsCoordinator;

abstract class _SessionRefreshWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionRefreshWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
  }
}
