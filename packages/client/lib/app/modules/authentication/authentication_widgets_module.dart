import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/module.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/authentication/presentation/presentation.dart';

class AuthenticationWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        BeachWavesModule(),
      ];

  @override
  exportedBinds(i) {
    i.addSingleton<NokhteStore>(
      () => NokhteStore(),
    );
    i.addSingleton<SmartTextStore>(
      () => SmartTextStore(),
    );
    i.add<TrailingTextStore>(
      () => TrailingTextStore(),
    );
    i.addSingleton<LoginScreenWidgetsCoordinator>(
      () => LoginScreenWidgetsCoordinator(
        nokhte: i.get<NokhteStore>(),
        smartTextStore: i.get<SmartTextStore>(),
        layer1BeachWaves: Modular.get<BeachWavesStore>(),
        layer2BeachWaves: Modular.get<BeachWavesStore>(),
        bottomTrailingText: i.get<TrailingTextStore>(),
        topTrailingText: i.get<TrailingTextStore>(),
      ),
    );
  }
}
