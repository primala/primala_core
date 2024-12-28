import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/session_information.dart';

mixin SessionPresence on Reactions {
  SessionPresenceCoordinator get presence;

  onInactive() async {
    await presence.updateUserStatus(SessionUserStatus.offline);
  }

  onResumed() async {
    await presence.updateUserStatus(SessionUserStatus.online);
    if (presence.sessionMetadataStore.everyoneIsOnline) {
      presence.incidentsOverlayStore.onCollaboratorJoined();
    }
  }
}
