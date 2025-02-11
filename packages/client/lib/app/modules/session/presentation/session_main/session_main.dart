export 'session_main_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionMainScreen extends HookWidget {
  final SessionMainCoordinator coordinator;

  const SessionMainScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    useOnAppLifecycleStateChange(
      (previous, current) => coordinator.onAppLifeCycleStateChange(
        current,
        onResumed: () async => await coordinator.onResumed(),
        onInactive: () async => await coordinator.onInactive(),
      ),
    );
    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        body: MultiHitStack(
          children: [
            FullScreen(
              child: Tap(
                store: coordinator.tap,
                child: Swipe(
                  store: coordinator.swipe,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Tint(coordinator.tint),
            BorderGlow(store: coordinator.borderGlow),
            SmartText('tap to talk', coordinator.smartText),
            SpeakLessSmileMore(coordinator.speakLessSmileMore),
            Rally(coordinator.rally),
            if (!coordinator.sessionMetadata.userIsSpeaking)
              LetEmCook(coordinator.letEmCook),
            SessionBar(
              coordinator.sessionBar,
              onDocTapped: () async => await coordinator.onDocTapped(),
              onPauseTapped: () async => await coordinator.onPauseTapped(),
            ),
            PurposeBanner(
              coordinator.purposeBanner,
            ),
            CollaboratorPresenceIncidentsOverlay(
              coordinator.presence.incidentsOverlayStore,
            ),
          ],
        ),
      );
    });
  }
}
