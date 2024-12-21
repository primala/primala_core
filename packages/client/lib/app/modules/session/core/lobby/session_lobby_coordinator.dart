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
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_lobby_coordinator.g.dart';

class SessionLobbyCoordinator = _SessionLobbyCoordinatorBase
    with _$SessionLobbyCoordinator;

abstract class _SessionLobbyCoordinatorBase
    with
        Store,
        RoutingArgs,
        ChooseGreeterType,
        BaseCoordinator,
        Reactions,
        SessionPresence {
  final SessionLobbyWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionStartersLogicCoordinator starterLogic;
  final CaptureSessionStart captureStart;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final SessionMetadataStore sessionMetadata;
  @override
  final CaptureScreen captureScreen;

  _SessionLobbyCoordinatorBase({
    required this.widgets,
    required this.captureStart,
    required this.tap,
    required this.starterLogic,
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
    disposers.add(sessionInitializationReactor());
    if (hasReceivedRoutingArgs) {
      await presence.listen();
      await presence.updateCurrentPhase(0.5);

      // if (sessionMetadata.presetType == PresetTypes.none) {
      //   await starterLogic.initialize(const Left(NoParams()));
      // } else {
      await sessionMetadata.refetchStaticMetadata();
      // }
    } else {
      widgets.navigationMenu.setWidgetVisibility(false);
      await presence.listen();
    }
    if (sessionMetadata.canStillLeave) {
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
    disposers.add(
        widgets.navigationMenu.actionSliderReactor(onActionSliderSelected: () {
      sessionMetadata.resetValues();
    }));
    disposers.add(sessionStartReactor());
    disposers.add(widgets.beachWavesMovieStatusReactor(enterGreeter));
    disposers.add(presetArticleTapReactor());
    disposers.add(sessionPresetReactor());
    disposers.add(sessionInitializationReactor());
    disposers.add(numberOfCollaboratorsReactor());
  }

  @action
  onOpen() async {
    await presence.updateCurrentPhase(0.5);
    widgets.onModalOpened();
  }

  @action
  onClose() async {
    await presence.updateCurrentPhase(1.0);
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
      await presence.updateCurrentPhase(1.0);
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

  sessionPresetReactor() =>
      reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          await onPresetInfoReceived();
        }
      });

  presetArticleTapReactor() =>
      reaction((p0) => widgets.presetArticle.tapCount, (p0) {
        if (widgets.navigationMenu.swipeUpBannerVisibility) return;
        widgets.presetArticle.showBottomSheet(
          sessionMetadata.presetEntity,
          onOpen: onOpen,
          onClose: onClose,
        );
      });

  @action
  showPresetInfo() {
    widgets.onPresetTypeReceived(
      sessionMetadata.presetEntity,
      onOpen: onOpen,
      onClose: onClose,
    );
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
                  presetType: sessionMetadata.presetType,
                ));
              },
            );
          }
        }),
      );

  sessionInitializationReactor() =>
      reaction((p0) => starterLogic.hasInitialized, (p0) async {
        if (p0) {
          await presence.listen();
        }
      });

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
    if (sessionMetadata.presetType == PresetTypes.collaborative) {
      return SessionConstants.collaborationGreeter;
    } else {
      if (groupIsLargerThanTwo) {
        return SessionConstants.groupGreeter;
      } else {
        return SessionConstants.duoGreeter;
      }
    }
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
