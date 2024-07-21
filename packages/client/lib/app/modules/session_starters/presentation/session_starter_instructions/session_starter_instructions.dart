export "session_starter_instructions_coordinator.dart";
export "session_starter_instructions_widgets_coordinator.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'session_starter_instructions_coordinator.dart';

class SessionStarterInstructionsScreen extends HookWidget {
  final SessionStarterInstructionsCoordinator coordinator;
  const SessionStarterInstructionsScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    final center = useCenterOffset();
    useEffect(() {
      coordinator.constructor(center);
      return () => coordinator.deconstructor();
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Tap(
        store: coordinator.tap,
        child: Swipe(
          store: coordinator.swipe,
          child: MultiHitStack(
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: FullScreen(
                  child: BeachWaves(
                    sandType: SandTypes.collaboration,
                    store: coordinator.widgets.beachWaves,
                  ),
                ),
              ),
              Opacity(
                opacity: .4,
                child: NokhteQrCode(
                  store: coordinator.widgets.qrCode,
                ),
              ),
              FullScreen(
                child: NokhteBlur(
                  store: coordinator.widgets.nokhteBlur,
                ),
              ),
              FullScreen(
                child: TouchRipple(
                  store: coordinator.widgets.touchRipple,
                ),
              ),
              SwipeGuide(
                orientation: SwipeGuideOrientation.right,
                store: coordinator.widgets.swipeGuide,
              ),
              Observer(builder: (context) {
                return Stack(
                  children: [
                    Center(
                      child: SmartText(
                        store: coordinator.widgets.smartText,
                        opacityDuration: Seconds.get(1),
                        topPadding:
                            coordinator.widgets.smartTextTopPaddingScalar,
                        topBump: .003,
                        // bottomPadding:
                        //     coordinator.widgets.smartTextBottomPaddingScalar,
                        // bottomBump: .003,
                      ),
                    ),
                    GestureCross(
                      showGlowAndOutline: true,
                      config: coordinator.widgets.gestureCrossConfig,
                      store: coordinator.widgets.gestureCross,
                    ),
                  ],
                );
              }),
              CenterInstructionalNokhte(
                store: coordinator.widgets.centerInstructionalNokhte,
              ),
              InstructionalGradientNokhte(
                store: coordinator.widgets.homeInstructionalNokhte,
              ),
              InstructionalGradientNokhte(
                store: coordinator.widgets.focusInstructionalNokhte,
              ),
              WifiDisconnectOverlay(
                store: coordinator.widgets.wifiDisconnectOverlay,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
