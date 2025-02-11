import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        PosthogModule(),
        HomeLogicModule(),
        ActiveGroupModule(),
        PreSessionModule(),
      ];

  @override
  binds(i) {
    i.add<HomeScreenCoordinator>(
      () => HomeScreenCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        contract: Modular.get<HomeContractImpl>(),
        activeGroup: Modular.get<ActiveGroup>(),
      ),
    );

    i.add<InformationCoordinator>(
      () => InformationCoordinator(),
    );
  }

  @override
  routes(r) {
    r.child(
      HomeConstants.relativeHomeScreen,
      transition: TransitionType.noTransition,
      child: (context) => HomeScreen(
        coordinator: Modular.get<HomeScreenCoordinator>(),
      ),
    );

    r.child(
      HomeConstants.relativeInformation,
      transition: TransitionType.noTransition,
      child: (context) => InformationScreen(
        coordinator: Modular.get<InformationCoordinator>(),
      ),
    );
  }
}
