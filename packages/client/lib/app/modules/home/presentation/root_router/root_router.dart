export 'home_screen_root_router_coordinator.dart';
export 'home_screen_root_router_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'root_router.dart';

class HomeScreenRootRouterScreen extends HookWidget {
  final HomeScreenRootRouterCoordinator coordinator;
  const HomeScreenRootRouterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);
    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: coordinator.isRouting
            ? Container()
            : MultiHitStack(
                children: [
                  FullScreen(
                      child: BeachWaves(
                    store: coordinator.widgets.beachWaves,
                  )),
                  NavigationCarousels(
                    store: coordinator.widgets.navigationCarousels,
                  ),
                  WifiDisconnectOverlay(
                    store: coordinator.widgets.wifiDisconnectOverlay,
                  ),
                ],
              ),
        // ),
      );
    });
  }
}
