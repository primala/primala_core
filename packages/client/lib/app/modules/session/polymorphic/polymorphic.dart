import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
export 'polymorphic_solo/polymorphic_solo.dart';

class SessionPolymorphicModule extends Module {
  @override
  List<Module> get imports => [
        PosthogModule(),
        SessionLogicModule(),
        SessionStartersLogicModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    i.add<PolymorphicSoloCoordinator>(
      () => PolymorphicSoloCoordinator(
        captureStart: Modular.get<CaptureNokhteSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<PolymorphicSoloWidgetsCoordinator>(),
        hold: HoldDetector(),
        tap: TapDetector(),
        captureEnd: Modular.get<CaptureNokhteSessionEnd>(),
        sessionStartersLogic: Modular.get<SessionStartersLogicCoordinator>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      SessionConstants.relativeRoot,
      transition: TransitionType.noTransition,
      child: (context) => PolymorphicSoloScreen(
        coordinator: Modular.get<PolymorphicSoloCoordinator>(),
      ),
    );
  }
}
