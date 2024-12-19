import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'needs_update_coordinator.dart';
export 'needs_update_widgets_coordinator.dart';

class NeedsUpdateScreen extends HookWidget {
  final NeedsUpdateCoordinator coordinator;
  const NeedsUpdateScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Hero(
              tag: 'beach',
              child: FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
            ),
            GestureCross(
              store: coordinator.widgets.gestureCross,
              config: GestureCrossConfiguration(),
            ),
            Tint(
              store: coordinator.widgets.tint,
            ),
            NokhteGradientText(
              store: coordinator.widgets.gradientText,
              content: 'Update Available',
              gradient: HomeConstants.needsToUpdateGrad,
              padding: EdgeInsets.only(
                bottom: height * .1,
              ),
            ),
          ],
        ));
  }
}
