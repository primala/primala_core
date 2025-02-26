import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionModule extends Module {
  @override
  List<Module> get imports => [
        SessionLogicModule(),
        PosthogModule(),
        ActiveGroupModule(),
        DocsLogicModule(),
        PreSessionModule(),
      ];

  @override
  binds(i) {
    i.add<LobbyCoordinator>(
      () => LobbyCoordinator(
        captureSessionStart: Modular.get<CaptureSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );

    i.add<PauseCoordinator>(
      () => PauseCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        tint: TintStore(),
      ),
    );

    i.add<SessionExitCoordinator>(
      () => SessionExitCoordinator(
        captureSessionEnd: Modular.get<CaptureSessionEnd>(),
        activeGroup: Modular.get<ActiveGroup>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
      ),
    );

    i.add<SessionMainCoordinator>(
      () => SessionMainCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        sessionBar: SessionBarStore(),
        tint: TintStore(),
        smartText: SmartTextStore(),
        borderGlow: BorderGlowStore(),
        swipe: SwipeDetector(),
        tap: TapDetector(),
        speakLessSmileMore: SpeakLessSmileMoreStore(),
        letEmCook: LetEmCookStore(),
        rally: RallyStore(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      SessionConstants.relativeLobby,
      transition: TransitionType.noTransition,
      child: (context) => LobbyScreen(
        coordinator: Modular.get<LobbyCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeExitSession,
      transition: TransitionType.noTransition,
      child: (context) => SessionExitScreen(
        coordinator: Modular.get<SessionExitCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeSessionStarter,
      transition: TransitionType.noTransition,
      child: (context) => SessionStarterScreen(
        coordinator: Modular.get<SessionStarterCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativePause,
      transition: TransitionType.noTransition,
      child: (context) => PauseScreen(
        coordinator: Modular.get<PauseCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeGreeter,
      transition: TransitionType.noTransition,
      child: (context) => const GreeterScreen(),
    );

    r.child(
      SessionConstants.relativeMainScreen,
      transition: TransitionType.noTransition,
      child: (context) => SessionMainScreen(
        coordinator: Modular.get<SessionMainCoordinator>(),
      ),
    );
  }
}
