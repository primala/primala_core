export 'session_presets_coordinator.dart';
export 'session_presets_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionPresetsScreen extends HookWidget {
  final SessionPresetsCoordinator coordinator;
  const SessionPresetsScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Tap(
        store: coordinator.tap,
        child: MultiHitStack(
          children: [
            NavigationMenu(
              store: coordinator.widgets.navigationMenu,
              inBetweenWidgets: MultiHitStack(
                children: [
                  SmartText(
                    store: coordinator.widgets.headerText,
                    opacityDuration: Seconds.get(1),
                    bottomPadding: .6,
                    bottomBump: .004,
                    fontWeight: FontWeight.w300,
                  ),
                  // const PresetKey(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: useScaledSize(
                        baseValue: 0.1,
                        bumpPerHundredth: -0.001,
                        screenSize: screenSize,
                      ),
                    ),
                    child: PresetsCards(
                      store: coordinator.widgets.presetCards,
                    ),
                  ),
                ],
              ),
            ),
            PresetArticle(
              store: coordinator.widgets.presetArticle,
            ),
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
