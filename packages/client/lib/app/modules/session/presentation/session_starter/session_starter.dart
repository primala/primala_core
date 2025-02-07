import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'session_starter_coordinator.dart';

class SessionStarterScreen extends HookWidget {
  final SessionStarterCoordinator coordinator;

  const SessionStarterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        isScrollable: true,
        showWidgets: coordinator.showWidgets,
        children: [
          HeaderRow(
            includeDivider: true,
            children: [
              LeftChevron(
                onTap: () => coordinator.onGoBack(),
              ),
              const SmartHeader(
                content: "Start Session",
              ),
              const LeftChevron(
                color: Colors.transparent,
              ),
            ],
          ),
          SessionStarterBody(
            onSubmit: coordinator.initializeSession,
            allDocs: coordinator.allDocuments,
            allUsers: coordinator.availableCollaborators,
          ),
        ],
      );
    });
  }
}
