export 'session_notes_waiting_coordinator.dart';
export 'session_notes_waiting_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'session_notes_waiting_coordinator.dart';

class SessionNotesWaitingScreen extends HookWidget {
  final SessionNotesWaitingCoordinator coordinator;
  const SessionNotesWaitingScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);
    useOnAppLifecycleStateChange(
        (previous, current) => coordinator.onAppLifeCycleStateChange(
              current,
              onResumed: () => coordinator.onResumed(),
              onInactive: () => coordinator.onInactive(),
            ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiHitStack(
        children: [
          FullScreen(
            child: BeachWaves(
              store: coordinator.widgets.beachWaves,
            ),
          ),
          Tint(
            store: coordinator.widgets.tint,
          ),
          MirroredText(
            store: coordinator.widgets.mirroredText,
          ),
          CollaboratorPresenceIncidentsOverlay(
            store: coordinator.presence.incidentsOverlayStore,
          ),
          WifiDisconnectOverlay(
            store: coordinator.widgets.wifiDisconnectOverlay,
          ),
        ],
      ),
      // ),
    );
  }
}
