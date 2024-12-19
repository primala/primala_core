import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'home.dart';

class HomeWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        ConnectivityModule(),
        GestureCrossModule(),
      ];

  @override
  exportedBinds(i) {
    i.add<HomeScreenRootRouterWidgetsCoordinator>(
      () => HomeScreenRootRouterWidgetsCoordinator(
        navigationCarousels: NavigationCarouselsStore(
          beachWaves: BeachWavesStore(),
        ),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
    i.add<QuickActionsRouterWidgetsCoordinator>(
      () => QuickActionsRouterWidgetsCoordinator(
        beachWaves: BeachWavesStore(),
      ),
    );
    i.add<HomeWidgetsCoordinator>(
      () => HomeWidgetsCoordinator(
        swipeGuides: SwipeGuideStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        navigationCarousels: NavigationCarouselsStore(
          beachWaves: BeachWavesStore(),
        ),
      ),
    );
    i.add<NeedsUpdateWidgetsCoordinator>(
      () => NeedsUpdateWidgetsCoordinator(
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        tint: TintStore(),
        beachWaves: BeachWavesStore(),
        gestureCross: Modular.get<GestureCrossStore>(),
        gradientText: NokhteGradientTextStore(),
      ),
    );
    i.add<HomeEntryWidgetsCoordinator>(
      () => HomeEntryWidgetsCoordinator(
        beachWaves: BeachWavesStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );
  }
}
