import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'lobby_coordinator.dart';

class LobbyScreen extends HookWidget {
  final LobbyCoordinator coordinator;

  const LobbyScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return const AnimatedScaffold(
      isScrollable: true,
      children: [
        HeaderRow(
          mainAxisAlignment: MainAxisAlignment.center,
          includeDivider: true,
          children: [
            SmartHeader(
              content: "Lobby",
            ),
          ],
        ),
        // LobbyBody(
        //   allSessions: coordinator.allSessions,
        // ),
      ],
    );
  }
}
