// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
part 'session_pause_widgets_coordinator.g.dart';

class SessionPauseWidgetsCoordinator = _SessionPauseWidgetsCoordinatorBase
    with _$SessionPauseWidgetsCoordinator;

abstract class _SessionPauseWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final PauseIconStore pauseIcon;
  final TintStore tint;

  _SessionPauseWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
    required this.pauseIcon,
    required this.tint,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
    pauseIcon.initFadeIn();
    tint.initMovie(const NoParams());
  }

  @action
  onTap() {
    tint.reverseMovie(const NoParams());
    pauseIcon.setWidgetVisibility(false);
  }
}
