import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class NavigationMenuModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<NavigationMenuStore>(
      () => NavigationMenuStore(
        blur: NokhteBlurStore(),
        beachWaves: BeachWavesStore(),
        swipe: SwipeDetector(),
        tint: TintStore(),
      ),
    );
  }
}
