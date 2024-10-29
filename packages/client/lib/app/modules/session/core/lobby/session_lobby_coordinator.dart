// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_metadata/user_metadata.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
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
  final UserMetadataCoordinator userMetadata;
  final CaptureNokhteSessionStart captureStart;
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
    required this.presence,
    required this.userMetadata,
    required this.captureScreen,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }
  @observable
  bool isNavigatingAway = false;

  @action
  constructor() async {
    widgets.constructor();
    await presence.listen();
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
    disposers.add(sessionStartReactor());
    disposers.add(widgets.beachWavesMovieStatusReactor(enterGreeter));
    disposers.add(presetArticleTapReactor());
    disposers.add(sessionPresetReactor());
  }

  @action
  onOpen() async {
    await presence.updateCurrentPhase(0.0);
    widgets.qrCode.setWidgetVisibility(false);
    widgets.primarySmartText.setWidgetVisibility(false);
  }

  @action
  onClose() async {
    await presence.updateCurrentPhase(1.0);
    widgets.qrCode.setWidgetVisibility(true);
    widgets.primarySmartText.setWidgetVisibility(true);
  }

  canStartTheSessionReactor() =>
      reaction((p0) => sessionMetadata.canStartTheSession, (p0) {
        print("hi can you start? ${p0}");
        if (p0) {
          widgets.onCanStartTheSession();
        } else {
          widgets.onRevertCanStartSession();
        }
      });

  sessionPresetReactor() =>
      reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          showPresetInfo();
          if (hasReceivedRoutingArgs) {
            await presence.updateCurrentPhase(1.0);
            disposers.add(tapReactor());
            disposers.add(canStartTheSessionReactor());
          }
        }
      });

  presetArticleTapReactor() =>
      reaction((p0) => widgets.presetArticle.tapCount, (p0) {
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
    widgets.onQrCodeReady(sessionMetadata.leaderUID);
    if (!hasReceivedRoutingArgs) {
      widgets.qrCode.setWidgetVisibility(false);
    }
  }

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(() {
          if (sessionMetadata.canStartTheSession) {
            widgets.onTap(
              tap.currentTapPosition,
              onTap: () async {
                await presence.startTheSession();
                await captureStart(CaptureNokhteSessionStartParams(
                  numberOfCollaborators: sessionMetadata.numberOfCollaborators,
                  presetType: sessionMetadata.presetType,
                ));
              },
            );
          }
        }),
      );

  sessionStartReactor() =>
      reaction((p0) => sessionMetadata.sessionHasBegun, (p0) {
        if (p0) {
          widgets.enterSession(sessionMetadata.isAValidSession);
        }
      });

  @action
  enterGreeter() => Modular.to.navigate(route);

  @computed
  String get route {
    if (groupIsLargerThanTwo) {
      if (isAPremiumSession) {
        if (sessionMetadata.isAValidSession) {
          return premiumSessionPath;
        } else {
          return monetizationSessionPath;
        }
      } else {
        return chooseGreeterType(SessionConstants.groupGreeter);
      }
    } else {
      return chooseGreeterType(SessionConstants.duoGreeter);
    }
  }

  deconstructor() {
    dispose();
    widgets.dispose();
  }

  @computed
  String get monetizationSessionPath =>
      userMetadata.isSubscribed ? '' : isNotSubscribedPath;

  String get isNotSubscribedPath =>
      userMetadata.hasUsedTrial ? SessionConstants.paywall : '';

  @computed
  String get premiumSessionPath {
    return chooseGreeterType(
        // isConsumingTrialSession
        //   ? SessionConstants.trialGreeter:
        SessionConstants.groupGreeter);
  }

  @computed
  bool get groupIsLargerThanTwo =>
      sessionMetadata.numberOfCollaborators.isGreaterThan(2);

  @computed
  bool get isConsumingTrialSession =>
      isAPremiumSession &&
      !userMetadata.hasUsedTrial &&
      !userMetadata.isSubscribed &&
      !sessionMetadata.leaderIsWhitelisted;

  @computed
  bool get isAPremiumSession =>
      sessionMetadata.numberOfCollaborators.isGreaterThanOrEqualTo(4);
}
