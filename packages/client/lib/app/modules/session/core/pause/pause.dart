export 'session_pause_coordinator.dart';
export 'session_pause_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/constants/constants.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionPauseScreen extends HookWidget {
  final SessionPauseCoordinator coordinator;
  const SessionPauseScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);

    final actionSlider = ActionSliderInformation(
        actionSliderOption: ActionSliderOptions.endSession);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Tap(
        store: coordinator.tap,
        child: MultiHitStack(
          children: [
            FullScreen(
              child: BeachWaves(
                store: coordinator.widgets.beachWaves,
              ),
            ),
            Tint(
              store: coordinator.widgets.tint,
            ),
            BorderGlow(store: BorderGlowStore()),
            PauseIcon(
              store: coordinator.widgets.pauseIcon,
            ),
            Observer(builder: (context) {
              return AnimatedOpacity(
                opacity: useWidgetOpacity(!coordinator.hasTapped),
                duration: Seconds.get(1),
                child: Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: GeneralizedActionSlider(
                    showWidget: true,
                    assetPath: actionSlider.assetPath,
                    sliderText: actionSlider.sliderText,
                    onSlideComplete: () {
                      Modular.to.navigate(
                        SessionConstants.actionSliderRouter,
                        arguments: {
                          HomeConstants.QUICK_ACTIONS_ROUTE:
                              SessionConstants.exit,
                        },
                      );
                      // sliderConfig.callback();
                    },
                  ),
                ),
              );
            }),
            WifiDisconnectOverlay(
              store: coordinator.widgets.wifiDisconnectOverlay,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
