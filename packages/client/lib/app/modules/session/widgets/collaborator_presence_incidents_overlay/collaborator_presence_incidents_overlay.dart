import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'collaborator_presence_incidents_overlay.dart';
export 'collaborator_presence_incidents_overlay_store.dart';
export 'collaborator_presence_incidents_overlay.dart';

class CollaboratorPresenceIncidentsOverlay extends StatelessWidget {
  final CollaboratorPresenceIncidentsOverlayStore store;
  const CollaboratorPresenceIncidentsOverlay(
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: Center(
                child: AnimatedOpacity(
                  opacity: useWidgetOpacity(store.showWidget),
                  duration: Seconds.get(1),
                  child: const Jost(
                    "Collaborator Is Offline",
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
