export 'session_lobby_coordinator.dart';
export 'context_header/context_header.dart';
export 'session_lobby_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
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
    final screenSize = useFullScreenSize();
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
              inBetweenWidgets: Stack(
                children: [
                  SmartText(
                    store: coordinator.widgets.primarySmartText,
                    topPadding: .25,
                    topBump: 0.0015,
                    opacityDuration: Seconds.get(1),
                  ),
                  ContextHeader(
                    store: coordinator.widgets.contextHeader,
                    scrollPercentage: .3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: useScaledSize(
                      baseValue: .09,
                      screenSize: screenSize,
                      bumpPerHundredth: .0021,
                    )
                        // screenSize.height * .06,
                        ),
                    child: NokhteQrCode(
                      store: coordinator.widgets.qrCode,
                    ),
                  ),
                  FullScreen(
                    child: TouchRipple(
                      store: coordinator.widgets.touchRipple,
                    ),
                  ),
                  CollaboratorPresenceIncidentsOverlay(
                    store: coordinator.presence.incidentsOverlayStore,
                  ),
                  PresetArticle(
                    store: coordinator.widgets.presetArticle,
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
