export 'session_lobby_coordinator.dart';
export 'context_header/context_header.dart';
export 'session_lobby_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionLobbyScreen extends HookWidget {
  final SessionLobbyCoordinator coordinator;
  const SessionLobbyScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);
    useOnAppLifecycleStateChange(
        (previous, current) => coordinator.onAppLifeCycleStateChange(
              current,
              onResumed: () => coordinator.onResumed(),
              onInactive: () => coordinator.onInactive(),
            ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Tap(
        store: coordinator.tap,
        child: MultiHitStack(
          children: [
            NavigationMenu(
              store: coordinator.widgets.navigationMenu,
              useJustTheSlideAction: true,
              inBetweenWidgets: Stack(
                children: [
                  FullScreen(
                    child: BeachWaves(
                      store: coordinator.widgets.navigationMenu.beachWaves,
                    ),
                  ),
                  SmartText(
                    store: coordinator.widgets.primarySmartText,
                    topPadding: .25,
                    topBump: 0.0015,
                    opacityDuration: Seconds.get(1),
                  ),
                  FullScreen(
                    child: TouchRipple(
                      store: coordinator.widgets.touchRipple,
                    ),
                  ),
                  CollaboratorPresenceIncidentsOverlay(
                    store: coordinator.presence.incidentsOverlayStore,
                  ),
                ],
              ),
            ),
            WifiDisconnectOverlay(
              store: coordinator.widgets.wifiDisconnectOverlay,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
