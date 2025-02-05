import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionModule extends Module {
  @override
  List<Module> get imports => [
        SessionLogicModule(),
        PreSessionModule(),
      ];

  @override
  binds(i) {
    i.add<LobbyCoordinator>(
      () => LobbyCoordinator(),
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
  }
}
