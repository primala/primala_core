export "quick_actions_router_coordinator.dart";
export "quick_actions_router_widgets_coordinator.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'quick_actions_router_coordinator.dart';

class QuickActionsRouterScreen extends HookWidget {
  final QuickActionsRouterCoordinator coordinator;
  const QuickActionsRouterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);

    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiHitStack(
          children: [
            RotatedBox(
              quarterTurns: coordinator.widgets.shouldRotate ? 2 : 0,
              child: FullScreen(
                child: BeachWaves(
                  sandType: coordinator.widgets.shouldRotate
                      ? SandTypes.collaboration
                      : SandTypes.home,
                  store: coordinator.widgets.beachWaves,
                ),
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
