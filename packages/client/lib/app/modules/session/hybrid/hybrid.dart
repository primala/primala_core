import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session/session.dart';

export './solo_hybrid/solo_hybrid.dart';
export 'group_hybrid/group_hybrid.dart';

class SessionHybridModule extends Module {
  @override
  List<Module> get imports => [
        PosthogModule(),
        PresetsModule(),
        SessionLogicModule(),
      ];
  @override
  void exportedBinds(i) {
    i.add<SessionSoloHybridCoordinator>(
      () => SessionSoloHybridCoordinator(
        tap: TapDetector(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionSoloHybridWidgetsCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        swipe: SwipeDetector(),
      ),
    );
    i.add<SessionPauseCoordinator>(
      () => SessionPauseCoordinator(
        captureStart: Modular.get<CaptureSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionPauseWidgetsCoordinator>(), //
      ),
    );
    i.add<SessionGroupHybridCoordinator>(
      () => SessionGroupHybridCoordinator(
        tap: TapDetector(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionGroupHybridWidgetsCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        hold: HoldDetector(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      SessionConstants.relativeSoloHybrid,
      transition: TransitionType.noTransition,
      child: (context) => SessionSoloHybridScreen(
        coordinator: Modular.get<SessionSoloHybridCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativePause,
      transition: TransitionType.noTransition,
      child: (context) => SessionPauseScreen(
        coordinator: Modular.get<SessionPauseCoordinator>(),
      ),
    );
    r.child(
      SessionConstants.relativeGroupHybrid,
      transition: TransitionType.noTransition,
      child: (context) => SessionGroupHybridScreen(
        coordinator: Modular.get<SessionGroupHybridCoordinator>(),
      ),
    );
  }
}
