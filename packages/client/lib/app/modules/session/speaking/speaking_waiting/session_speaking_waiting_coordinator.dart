// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_coordinator.dart';
import 'package:nokhte/app/core/modules/session_presence/session_presence.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'session_speaking_waiting_widgets_coordinator.dart';
part 'session_speaking_waiting_coordinator.g.dart';

class SessionSpeakingWaitingCoordinator = _SessionSpeakingWaitingCoordinatorBase
    with _$SessionSpeakingWaitingCoordinator;

abstract class _SessionSpeakingWaitingCoordinatorBase extends BaseCoordinator
    with Store {
  final SessionSpeakingWaitingWidgetsCoordinator widgets;
  final SessionPresenceCoordinator presence;
  final ListenToSessionMetadataStore sessionMetadata;

  _SessionSpeakingWaitingCoordinatorBase({
    required super.captureScreen,
    required this.widgets,
    required this.presence,
  }) : sessionMetadata = presence.listenToSessionMetadataStore;

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await updateCurrentPhase();
  }

  initReactors() {
    presence.initReactors(
      onCollaboratorJoined: () {
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () {
        widgets.onCollaboratorLeft();
      },
    );
    collaboratorPhaseReactor();
    widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () {},
      onLongReConnected: () {},
      onDisconnected: () {},
    );
  }

  @action
  onInactive() async {
    await presence
        .updateOnlineStatus(UpdatePresencePropertyParams.userNegative());
  }

  @action
  onResumed() async {
    await presence
        .updateOnlineStatus(UpdatePresencePropertyParams.userAffirmative());
    await presence.updateCurrentPhase(2.0);
    if (sessionMetadata.everyoneIsOnline) {
      presence.incidentsOverlayStore.onCollaboratorJoined();
    }
  }

  collaboratorPhaseReactor() => reaction(
        (p0) => sessionMetadata.currentPhases,
        (p0) {
          if (sessionMetadata.canMoveIntoSession) {
            widgets.onReadyToTransition();
          }
        },
      );

  updateCurrentPhase() async {
    Timer.periodic(Seconds.get(0, milli: 500), (timer) async {
      if (sessionMetadata.userPhase != 2.0) {
        await presence.updateCurrentPhase(2.0);
      } else {
        timer.cancel();
      }
    });
  }
}
