export 'session_playlists_coordinator.dart';
export 'session_playlists_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionPlaylistsScreen extends HookWidget {
  final SessionPlaylistsCoordinator coordinator;
  const SessionPlaylistsScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
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
                ],
              ),
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
