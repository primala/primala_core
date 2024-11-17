export 'storage_content_coordinator.dart';
export 'storage_content_widgets_coordinator.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class StorageContentScreen extends HookWidget {
  final StorageContentCoordinator coordinator;
  const StorageContentScreen({
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
            BackButton(
              store: coordinator.widgets.backButton,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: useScaledSize(
                  baseValue: .11,
                  screenSize: screenSize,
                ),
              ),
              child: ContentCard(
                store: coordinator.widgets.contentCard,
                content: coordinator.nokhteSessionArtifacts.content,
              ),
            ),
            WifiDisconnectOverlay(
              store: coordinator.widgets.wifiDisconnectOverlay,
            ),
          ],
        ),
        // ),
      );
    });
  }
}
