export './settings_coordinator.dart';
export './settings_widgets_coordinator.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/settings/settings.dart';

class SettingsScreen extends HookWidget {
  final SettingsCoordinator coordinator;
  const SettingsScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.dispose();
    }, []);

    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiHitStack(
          children: [
            BeachWaves(
              store: coordinator.widgets.beachWaves,
            ),
            SettingsLayout(
              store: coordinator.widgets.settingsLayout,
            ),
            BackButton(
              store: coordinator.widgets.backButton,
              overridedColor: Colors.white,
            ),
            WifiDisconnectOverlay(
              store: coordinator.widgets.wifiDisconnectOverlay,
            ),
          ],
        ),
      );
    });
  }
}
