// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/groups.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'exit_coordinator.g.dart';

class SessionExitCoordinator = _SessionExitCoordinatorBase
    with _$SessionExitCoordinator;

abstract class _SessionExitCoordinatorBase
    with Store, Reactions, BaseWidgetsCoordinator {
  final SessionPresenceCoordinator presence;
  final SessionMetadataStore sessionMetadata;
  final CaptureSessionEnd captureSessionEnd;
  final ActiveGroup activeGroup;

  _SessionExitCoordinatorBase({
    required this.presence,
    required this.captureSessionEnd,
    required this.activeGroup,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() async {
    await presence.updateUserStatus(
      SessionUserStatus.readyToLeave,
    );
    disposers.add(sessionExitReactor());
    setShowWidgets(true);
  }

  sessionExitReactor() =>
      reaction((p0) => sessionMetadata.canExitTheSession, (p0) async {
        if (p0) {
          if (sessionMetadata.userIndex == 0) {
            await presence.deleteSession(sessionMetadata.sessionId);
            await captureSessionEnd(
              CaptureSessionEndParams(
                sessionStartTime: sessionMetadata.sessionStartTime,
                numberOfCollaborators:
                    sessionMetadata.collaboratorInformation.length,
              ),
            );
          }
          activeGroup.setGroupEntity(GroupEntity.initial());
          setShowWidgets(false);
          Timer(Seconds.get(0, milli: 500), () {
            Modular.to.navigate(HomeConstants.homeScreen);
          });
        }
      });

  @action
  onTap() async {
    if (!showWidgets) return;
    await presence.updateUserStatus(SessionUserStatus.online);
    setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(SessionConstants.mainScreen);
    });
  }

  @override
  @action
  dispose() async {
    super.dispose();
    await presence.dispose();
    Modular.dispose<SessionPresenceCoordinator>();
  }
}
