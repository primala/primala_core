// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/deep_links/deep_links.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/session_presence/session_presence.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_lobby_coordinator.g.dart';

class SessionLobbyCoordinator = _SessionLobbyCoordinatorBase
    with _$SessionLobbyCoordinator;

abstract class _SessionLobbyCoordinatorBase extends BaseCoordinator with Store {
  final SessionLobbyWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionPresenceCoordinator presence;
  final ListenToSessionMetadataStore sessionMetadata;
  final DeepLinksCoordinator deepLinks;

  _SessionLobbyCoordinatorBase({
    required super.captureScreen,
    required this.widgets,
    required this.deepLinks,
    required this.tap,
    required this.presence,
  }) : sessionMetadata = presence.listenToSessionMetadataStore;

  @observable
  bool isNavigatingAway = false;

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await presence.listen();
    await deepLinks.getDeepLink(DeepLinkTypes.nokhteSessionBearer);
    await captureScreen(Screens.nokhteSessionLobby);
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
    if (sessionMetadata.everyoneIsOnline) {
      presence.incidentsOverlayStore.onCollaboratorJoined();
    }
  }

  @action
  initReactors() {
    deepLinkReactor();
    widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
      },
    );
    presence.initReactors(
      onCollaboratorJoined: () {
        setDisableAllTouchFeedback(false);
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () {
        setDisableAllTouchFeedback(true);
        widgets.onCollaboratorLeft();
      },
    );
    if (isTheLeader) {
      tapReactor();
    }
    sessionStartReactor();
    widgets.beachWavesMovieStatusReactor(enterGreeter);
  }

  deepLinkReactor() => reaction(
        (p0) => deepLinks.link,
        (p0) => widgets.onQrCodeReady(p0),
      );

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(() async {
          widgets.onTap(
            tap.currentTapPosition,
            onTap: () async => await presence.startTheSession(),
          );
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
  String get route => sessionMetadata.numberOfCollaborators.isGreaterThan(2)
      ? '/session/shared/group_greeter'
      : '/session/shared/duo_greeter';

  @computed
  bool get isTheLeader => Modular.args.data["qrCodeData"] != null;
}
