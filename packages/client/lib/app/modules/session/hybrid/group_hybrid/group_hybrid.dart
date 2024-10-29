export 'session_group_hybrid_coordinator.dart';
export 'session_group_hybrid_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionGroupHybridScreen extends HookWidget {
  final SessionGroupHybridCoordinator coordinator;
  const SessionGroupHybridScreen({
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
        child: Hold(
          store: coordinator.hold,
          child: MultiHitStack(
            children: [
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
              HalfScreenTint(
                store: coordinator.widgets.othersAreTakingNotesTint,
              ),
              Tint(
                store: coordinator.widgets.othersAreTalkingTint,
              ),
              BorderGlow(
                store: coordinator.widgets.borderGlow,
              ),
              MirroredText(
                store: coordinator.widgets.mirroredText,
              ),
              RefreshBanner(
                store: coordinator.widgets.refreshBanner,
              ),
              SpeakLessSmileMore(
                store: coordinator.widgets.speakLessSmileMore,
              ),
              LetEmCook(
                store: coordinator.widgets.letEmCook,
              ),
              FullScreen(
                child: TouchRipple(
                  store: coordinator.widgets.touchRipple,
                ),
              ),
              SessionNavigation(
                store: coordinator.widgets.sessionNavigation,
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
      ),
      // ),
    );
  }
}
