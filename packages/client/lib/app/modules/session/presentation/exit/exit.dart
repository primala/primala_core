import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'exit_coordinator.dart';

class SessionExitScreen extends HookWidget {
  final SessionExitCoordinator coordinator;

  const SessionExitScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () async => await coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () => coordinator.onTap(),
        child: AnimatedScaffold(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          showWidgets: coordinator.showWidgets,
          children: [
            const Center(
              child: Jost(
                'Waiting to leave',
                fontSize: 24,
                shouldCenter: true,
              ),
            ),
            const SizedBox(height: 20),
            Jost(
              'tap to return to the session',
              fontSize: 16,
              fontColor: Colors.black.withOpacity(.6),
              softWrap: true,
              shouldCenter: true,
            ),
            const SizedBox(height: 80),
          ],
        ),
      );
    });
  }
}
