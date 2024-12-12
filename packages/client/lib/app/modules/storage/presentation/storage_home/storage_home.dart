export 'storage_home_coordinator.dart';
export 'storage_home_widgets_coordinator.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class StorageHomeScreen extends HookWidget {
  final StorageHomeCoordinator coordinator;
  const StorageHomeScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
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
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
              Center(
                child: SmartText(
                  store: coordinator.widgets.headerText,
                  bottomPadding: .75,
                  opacityDuration: Seconds.get(1),
                ),
              ),
              BackButton(
                store: coordinator.widgets.backButton,
                overridedColor: Colors.white,
                topPaddingScalar: .085,
              ),
              GroupDisplay(
                store: coordinator.widgets.groupDisplay,
              ),
              GroupRegistration(
                store: coordinator.widgets.groupRegistration,
              ),
              // Observer(builder: (context) {
              //   return Padding(
              //     padding: EdgeInsets.only(top: height * .13),
              //     child: SessionCard(
              //       store: coordinator.widgets.sessionCard,
              //       sessions: coordinator.nokhteSessionArtifacts,
              //     ),
              //   );
              // }),
              FullScreen(
                child: NokhteBlur(
                  store: coordinator.widgets.blur,
                ),
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
