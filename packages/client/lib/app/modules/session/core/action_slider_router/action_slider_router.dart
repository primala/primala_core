export "action_slider_router_coordinator.dart";
export "action_slider_router_widgets_coordinator.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'action_slider_router_coordinator.dart';

class ActionSliderRouterScreen extends HookWidget {
  final ActionSliderRouterCoordinator coordinator;
  const ActionSliderRouterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);

    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiHitStack(
          children: [
            FullScreen(
              child: BeachWaves(
                store: coordinator.widgets.beachWaves,
              ),
            ),
            AnimatedOpacity(
              opacity: useWidgetOpacity(!coordinator.widgets.showBeachWaves),
              duration: Seconds.get(1),
              child: FullScreen(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        // ),
      );
    });
  }
}
