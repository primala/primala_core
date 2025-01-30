import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/home/home.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        PosthogModule(),
        HomeLogicModule(),
      ];

  @override
  binds(i) {
    i.add<HomeScreenCoordinator>(
      () => HomeScreenCoordinator(
        contract: Modular.get<HomeContractImpl>(),
      ),
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
  }
}
