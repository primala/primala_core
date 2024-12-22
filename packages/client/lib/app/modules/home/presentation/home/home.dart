export 'home_coordinator.dart';
export 'home_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';

class HomeScreen extends HookWidget {
  final HomeCoordinator coordinator;
  const HomeScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(context);
      return () => coordinator.deconstructor();
    }, []);
    final screenSize = useFullScreenSize();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiHitStack(
        children: [
          NavigationCarousels(
            store: coordinator.widgets.navigationCarousels,
            inBetweenWidgets: Observer(builder: (context) {
              return MultiHitStack(
                children: [
                  AnimatedOpacity(
                    opacity:
                        useWidgetOpacity(coordinator.widgets.qrSectionIsActive),
                    duration: Seconds.get(1),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: useScaledSize(
                        baseValue: .1,
                        screenSize: screenSize,
                        bumpPerHundredth: .0021,
                      )
                          // screenSize.height * .06,
                          ),
                      child: NokhteQrCode(
                        store: coordinator.widgets.qrCode,
                      ),
                    ),
                  ),
                  SmartText(
                    store: coordinator.widgets.smartText,
                    topPadding: .21,
                    topBump: 0.0015,
                    opacityDuration: Seconds.get(1),
                  ),
                  CollaboratorCard(
                    store: coordinator.widgets.collaboratorCard,
                  ),
                  QrScanner(
                    store: coordinator.widgets.qrScanner,
                  ),
                ],
              );
            }),
          ),
          WifiDisconnectOverlay(
            store: coordinator.widgets.wifiDisconnectOverlay,
          ),
        ],
      ),
    );
  }
}
