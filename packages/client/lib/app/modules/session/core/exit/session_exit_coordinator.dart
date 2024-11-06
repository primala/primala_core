// ignore_for_file: must_be_immutable, library_private_types_in_public_api,
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_exit_coordinator.g.dart';

class SessionExitCoordinator = _SessionExitCoordinatorBase
    with _$SessionExitCoordinator;

abstract class _SessionExitCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        BaseCoordinator,
        Reactions,
        SessionPresence,
        BaseExitCoordinator {
  final SessionExitWidgetsCoordinator widgets;
  @override
  final SwipeDetector swipe;
  @override
  final SessionMetadataStore sessionMetadata;
  final CleanUpCollaborationArtifactsCoordinator cleanUpCollaborationArtifacts;
  final CaptureSessionEnd captureEnd;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionExitCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
    required this.swipe,
    required this.captureEnd,
    required this.presence,
    required this.cleanUpCollaborationArtifacts,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initEnRouteActions();
    initBaseCoordinatorActions();
    initBaseExitCoordinatorActions();
  }

  @observable
  bool showCollaboratorIncidents = true;

  @observable
  bool phaseHasBeenSet = false;

  @action
  setShowCollaboratorIncidents(bool newVal) =>
      showCollaboratorIncidents = newVal;

  @action
  constructor() async {
    phaseHasBeenSet = false;
    widgets.constructor();
    initReactors();
    await presence.updateCurrentPhase(4.0);
    sessionMetadata.setAffirmativePhase(4.0);
    disposers.add(
      userPhaseReactor(
        initWrapUp: () async => await onReturnHome(),
      ),
    );
    swipe.setMinDistance(100.0);
    await captureScreen(SessionConstants.exit);
  }

  @observable
  bool isGoingHome = false;

  @action
  setIsGoingHome(bool newVal) => isGoingHome = newVal;

  @action
  initReactors() {
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
      },
    ));
    disposers.add(presence.initReactors(
      onCollaboratorJoined: () {
        setDisableAllTouchFeedback(false);
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () {
        setDisableAllTouchFeedback(true);
        widgets.onCollaboratorLeft();
      },
    ));
    disposers.add(
      widgets.beachWavesMovieStatusReactor(
        onBackToSession: () {
          if (sessionMetadata.presetType == PresetTypes.collaborative) {
            Modular.to.navigate(SessionConstants.soloHybrid);
          } else {
            Modular.to.navigate(SessionConstants.groupHybrid);
          }
        },
      ),
    );
    // if (isNotASocraticSession) {
    disposers.add(swipeReactor(onSwipeDown: () {
      widgets.onReadyToGoBack(() async {
        await presence.updateCurrentPhase(2.0);
        setDisableAllTouchFeedback(true);
      });
    }));
    // }
  }

  @action
  onReturnHome() async {
    showCollaboratorIncidents = false;
    presence.dispose();
    if (sessionMetadata.userIndex == 0) {
      await presence.completeTheSession();
      await captureEnd(
        CaptureSessionEndParams(
          sessionsStartTime: sessionMetadata.sessionStartTime,
          presetType: sessionMetadata.presetType,
        ),
      );
    }
    widgets.initHomeTransition();
  }

  @computed
  SessionScreenTypes get phoneRole => sessionMetadata.screenType;

  deconstructor() {
    presence.dispose();
    dispose();
  }
}
