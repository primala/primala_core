export 'storage_home_coordinator.dart';
export 'storage_home_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
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
              NavigationCarousels(
                store: coordinator.widgets.navigationCarousels,
                showAtEnd: true,
                inBetweenWidgets: MultiHitStack(
                  children: [
                    GroupDisplay(
                      store: coordinator.widgets.groupDisplay,
                    ),
                    GroupRegistration(
                      store: coordinator.widgets.groupRegistration,
                    ),
                  ],
                ),
              ),
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
    );
  }
}
