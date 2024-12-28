// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/session_information.dart';
part 'session_lobby_coordinator.g.dart';

class SessionLobbyCoordinator = _SessionLobbyCoordinatorBase
    with _$SessionLobbyCoordinator;

abstract class _SessionLobbyCoordinatorBase
    with Store, RoutingArgs, BaseCoordinator, Reactions, SessionPresence {
  final SessionLobbyWidgetsCoordinator widgets;
  final TapDetector tap;
  final CaptureSessionStart captureStart;
  @override
  final SessionPresenceCoordinator presence;
  final SessionMetadataStore sessionMetadata;
  @override
  final CaptureScreen captureScreen;

  _SessionLobbyCoordinatorBase({
    required this.widgets,
    required this.captureStart,
    required this.tap,
    required this.presence,
    required this.captureScreen,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }
  @observable
  bool isNavigatingAway = false;

  @action
  constructor() async {
    widgets.constructor();
    if (hasReceivedRoutingArgs) {
      await presence.listen();
    } else {
      widgets.navigationMenu.setWidgetVisibility(false);
      await presence.listen();
    }
    await onPresetInfoReceived();
    if (sessionMetadata.canStillAbort) {
      widgets.navigationMenu.setWidgetVisibility(false);
    }
    initReactors();
    await captureScreen(SessionConstants.lobby);
  }

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
    disposers.add(widgets.navigationMenu.actionSliderReactor());
    disposers.add(sessionStartReactor());
    disposers.add(widgets.beachWavesMovieStatusReactor(enterGreeter));
    disposers.add(numberOfCollaboratorsReactor());
  }

  @action
  onOpen() async {
    await presence.updateUserStatus(SessionUserStatus.hasJoined);
    widgets.onModalOpened();
  }

  @action
  onClose() async {
    await presence.updateUserStatus(SessionUserStatus.readyToStart);
    widgets.qrCode.setWidgetVisibility(true);
    if (hasReceivedRoutingArgs &&
        sessionMetadata.numberOfCollaborators.isLessThan(2)) {
      widgets.navigationMenu.setWidgetVisibility(true);
    }
    widgets.primarySmartText.setWidgetVisibility(true);
  }

  @action
  onPresetInfoReceived() async {
    showPresetInfo();
    if (hasReceivedRoutingArgs) {
      await presence.updateUserStatus(SessionUserStatus.readyToStart);
      disposers.add(tapReactor());
      disposers.add(canStartTheSessionReactor());
    }
  }

  canStartTheSessionReactor() =>
      reaction((p0) => sessionMetadata.canStartTheSession, (p0) {
        if (p0) {
          widgets.onCanStartTheSession();
        } else {
          widgets.onRevertCanStartSession();
        }
      });

  numberOfCollaboratorsReactor() =>
      reaction((p0) => sessionMetadata.numberOfCollaborators, (p0) {
        if (p0.isGreaterThan(1)) {
          widgets.navigationMenu.setWidgetVisibility(false);
        }
      });

  // sessionPresetReactor() =>
  //     reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
  //       if (p0 == StoreState.loaded) {
  //         await onPresetInfoReceived();
  //       }
  //     });

  @action
  showPresetInfo() {
    widgets.contextHeader.setHeader(
      sessionMetadata.currentGroup,
      sessionMetadata.currentQueue,
    );
    widgets.onQrCodeReady(sessionMetadata.leaderUID);
  }

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(() {
          if (sessionMetadata.canStartTheSession) {
            widgets.onTap(
              tap.currentTapPosition,
              onTap: () async {
                await presence.startTheSession();
                await captureStart(CaptureSessionStartParams(
                  numberOfCollaborators: sessionMetadata.numberOfCollaborators,
                ));
              },
            );
          }
        }),
      );

  sessionStartReactor() =>
      reaction((p0) => sessionMetadata.sessionHasBegun, (p0) {
        if (p0) {
          widgets.enterSession();
        }
      });

  @action
  enterGreeter() => Modular.to.navigate(route);

  @computed
  String get route {
    return SessionConstants.collaborationGreeter;
  }

  deconstructor() async {
    // if (!sessionMetadata.sessionHasBegun) {
    // await starterLogic.nuke();
    // await presence.dispose();
    // Modular.dispose<SessionLogicModule>();
    // }
    dispose();
    widgets.dispose();
  }

  @computed
  bool get groupIsLargerThanTwo =>
      sessionMetadata.numberOfCollaborators.isGreaterThan(2);
}
