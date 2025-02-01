import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/modules/docs/docs.dart';

class DocsModule extends Module {
  @override
  List<Module> get imports => [];
  @override
  binds(i) {
    i.add<DocsHubCoordinator>(
      () => DocsHubCoordinator(),
    );
  }

  @override
  routes(r) {
    r.child(
      DocsConstants.relativeDocsHub,
      transition: TransitionType.noTransition,
      child: (context) => DocsHubScreen(
        coordinator: Modular.get<DocsHubCoordinator>(),
      ),
    );
  }
}
