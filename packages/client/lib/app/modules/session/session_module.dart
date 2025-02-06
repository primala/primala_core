import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionModule extends Module {
  @override
  List<Module> get imports => [
        SessionLogicModule(),
        PosthogModule(),
        DocsLogicModule(),
        PreSessionModule(),
      ];

  @override
  binds(i) {
    i.add<LobbyCoordinator>(
      () => LobbyCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
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
      SessionConstants.relativeSessionStarter,
      transition: TransitionType.noTransition,
      child: (context) => SessionStarterScreen(
        coordinator: Modular.get<SessionStarterCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeGreeter,
      transition: TransitionType.noTransition,
      child: (context) => const GreeterScreen(),
    );

    // r.child(
    //   SessionConstants.relativeMainScreen,
    //   transition: TransitionType.noTransition,
    //   child: (context) => MainScreen(),
    // );
  }
}
