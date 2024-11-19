export 'session_solo_hybrid_coordinator.dart';
export 'session_solo_hybrid_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionSoloHybridScreen extends HookWidget {
  final SessionSoloHybridCoordinator coordinator;
  const SessionSoloHybridScreen({
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
      body: Swipe(
        store: coordinator.swipe,
        child: MultiHitStack(
          children: [
            Tap(
              store: coordinator.tap,
              child: FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
            ),
            HalfScreenTint(
              store: coordinator.widgets.othersAreTalkingTint,
            ),
            BorderGlow(
              store: coordinator.widgets.borderGlow,
            ),
            Center(
              child: SmartText(
                store: coordinator.widgets.secondarySmartText,
                bottomPadding: .3,
                opacityDuration: Seconds.get(1),
              ),
            ),
            RefreshBanner(
              store: coordinator.widgets.refreshBanner,
            ),
            Center(
              child: SmartText(
                store: coordinator.widgets.primarySmartText,
                topPadding: .3,
                opacityDuration: Seconds.get(1),
              ),
            ),
            Rally(
              store: coordinator.widgets.rally,
            ),
            PurposeBanner(
              store: coordinator.widgets.purposeBanner,
            ),
            SpeakLessSmileMore(
              store: coordinator.widgets.speakLessSmileMore,
            ),
            FullScreen(
              child: TouchRipple(
                store: coordinator.widgets.touchRipple,
              ),
            ),
            CollaboratorPresenceIncidentsOverlay(
              store: coordinator.presence.incidentsOverlayStore,
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
