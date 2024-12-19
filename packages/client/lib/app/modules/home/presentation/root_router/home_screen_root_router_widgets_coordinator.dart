// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'home_screen_root_router_widgets_coordinator.g.dart';

class HomeScreenRootRouterWidgetsCoordinator = _HomeScreenRootRouterWidgetsCoordinatorBase
    with _$HomeScreenRootRouterWidgetsCoordinator;

abstract class _HomeScreenRootRouterWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, EnRoute, EnRouteRouter {
  final BeachWavesStore beachWaves;
  final NavigationCarouselsStore navigationCarousels;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _HomeScreenRootRouterWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.navigationCarousels,
  }) : beachWaves = navigationCarousels.beachWaves {
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  WaterDirection waterDirection = WaterDirection.down;

  @action
  constructor() {
    initEnRouteActions();
    navigationCarousels.setCanScroll(false);
    navigationCarousels.initFadeIn();
    beachWaves.setMovieMode(BeachWaveMovieModes.onShore);
    beachWaves.currentStore.setControl(Control.mirror);
  }
}
