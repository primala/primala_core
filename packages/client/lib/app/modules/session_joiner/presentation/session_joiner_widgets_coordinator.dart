// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
part 'session_joiner_widgets_coordinator.g.dart';

class SessionJoinerWidgetsCoordinator = _SessionJoinerWidgetsCoordinatorBase
    with _$SessionJoinerWidgetsCoordinator;

abstract class _SessionJoinerWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, SwipeNavigationUtils {
  final QrScannerStore qrScanner;
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  final NavigationMenuStore navigationMenu;

  _SessionJoinerWidgetsCoordinatorBase({
    required this.qrScanner,
    required this.wifiDisconnectOverlay,
    required this.navigationMenu,
  }) : beachWaves = navigationMenu.beachWaves {
    beachWaves.currentStore.setWidgetVisibility(false);
    initSwipeNavigationUtils();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    navigationMenu
        .setNavigationMenuType(NavigationMenuType.sessionLobbyNoOneJoined);
    beachWaves.setMovieMode(BeachWaveMovieModes.emptyTheOcean);
    disposers.add(beachWavesReactor());
  }

  beachWavesReactor() => reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          Modular.to.navigate(SessionConstants.lobby);
        }
      });

  @action
  enterSession() {
    beachWaves.setMovieMode(BeachWaveMovieModes.emptyOceanToInvertedDeepSea);
    beachWaves.currentStore.initMovie(const NoParams());
    qrScanner.fadeOut();
    navigationMenu.setWidgetVisibility(false);
  }
}
