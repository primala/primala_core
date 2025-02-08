import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      return () => coordinator.dispose();
    }, []);
    useOnAppLifecycleStateChange(
      (previous, current) => coordinator.onAppLifeCycleStateChange(
        current,
        onResumed: () async => await coordinator.onResumed(),
        onInactive: () async => await coordinator.onInactive(),
      ),
    );
    return Observer(builder: (context) {
      return AnimatedScaffold(
        isScrollable: true,
        showWidgets: coordinator.showWidgets,
        children: [
          const HeaderRow(
            title: "Lobby",
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: const Jost(
              'Online',
              fontSize: 28,
            ),
          ),
          CollaboratorsCarousel(
            collaborators: coordinator.onlineCollaborators,
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: const Jost(
              'Offline',
              fontSize: 28,
            ),
          ),
          CollaboratorsCarousel(
            collaborators: coordinator.offlineCollaborators,
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: const Jost(
              'Documents',
              fontSize: 28,
            ),
          ),
          DocsCarousel(
            docs: coordinator.sessionMetadata.documents,
          ),
          const SizedBox(height: 20),
          if (coordinator.isSessionLead)
            GenericButton(
              isEnabled: coordinator.canStartSession,
              label: "Start Session",
              onPressed: () async => await coordinator.startSession(),
            )
        ],
      );
    });
  }
}
