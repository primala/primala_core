export 'polymorphic_solo_coordinator.dart';
export 'polymorphic_solo_widgets_coordinator.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class PolymorphicSoloScreen extends HookWidget {
  final PolymorphicSoloCoordinator coordinator;
  const PolymorphicSoloScreen({
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
        child: Hold(
          store: coordinator.hold,
          child: MultiHitStack(
            children: [
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
              BorderGlow(
                store: coordinator.widgets.borderGlow,
              ),
              BackButton(
                store: coordinator.widgets.backButton,
                overridedColor: Colors.white,
              ),
              MirroredText(
                store: coordinator.widgets.mirroredText,
              ),
              SpeakLessSmileMore(
                store: coordinator.widgets.speakLessSmileMore,
              ),
              FullScreen(
                child: TouchRipple(
                  store: coordinator.widgets.touchRipple,
                ),
              ),
              Center(
                child: SmartText(
                  store: coordinator.widgets.secondarySmartText,
                  bottomPadding: .3,
                  opacityDuration: Seconds.get(1),
                ),
              ),
              Center(
                child: SmartText(
                  store: coordinator.widgets.primarySmartText,
                  topPadding: .3,
                  opacityDuration: Seconds.get(1),
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
