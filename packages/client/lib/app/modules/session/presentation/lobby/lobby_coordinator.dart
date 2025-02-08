// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'lobby_coordinator.g.dart';

class LobbyCoordinator = _LobbyCoordinatorBase with _$LobbyCoordinator;

abstract class _LobbyCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseCoordinator, Reactions {
  final SessionPresenceCoordinator presence;
  final SessionMetadataStore sessionMetadata;
  @override
  final CaptureScreen captureScreen;
  final CaptureSessionStart captureSessionStart;

  _LobbyCoordinatorBase({
    required this.presence,
    required this.captureScreen,
    required this.captureSessionStart,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() async {
    await presence.updateUserStatus(
      SessionUserStatus.online,
    );
    await presence.listen();
    disposers.add(metadataStateCoordinator());
    disposers.add(sessionStarterReactor());
  }

  @action
  onResumed() async => presence.updateUserStatus(SessionUserStatus.online);

  @action
  onInactive() async => presence.updateUserStatus(SessionUserStatus.offline);

  @action
  startSession() async {
    await presence.startTheSession();
    await captureSessionStart(
      CaptureSessionStartParams(
        numberOfCollaborators: sessionMetadata.collaboratorInformation.length,
        numberOfDocs: sessionMetadata.documentIds.length,
      ),
    );
  }

  metadataStateCoordinator() =>
      reaction((p0) => sessionMetadata.state, (p0) async {
        if (p0 != StoreState.loaded) return;
        setShowWidgets(true);
      });

  sessionStarterReactor() =>
      reaction((p0) => sessionMetadata.sessionHasBegun, (p0) {
        if (!p0) return;
        setShowWidgets(false);
        Timer(Seconds.get(0, milli: 500), () {
          Modular.to.navigate(SessionConstants.greeter);
        });
      });

  @computed
  bool get isSessionLead => sessionMetadata.userIndex == 0;

  @computed
  bool get canStartSession => offlineCollaborators.isEmpty;

  @computed
  List<SessionUserEntity> get onlineCollaborators {
    final collaborators = sessionMetadata.collaboratorInformation;
    return collaborators
        .where(
            (element) => element.sessionUserStatus == SessionUserStatus.online)
        .toList();
  }

  @computed
  List<SessionUserEntity> get offlineCollaborators {
    final collaborators = sessionMetadata.collaboratorInformation;
    return collaborators
        .where(
            (element) => element.sessionUserStatus == SessionUserStatus.offline)
        .toList();
  }
}
