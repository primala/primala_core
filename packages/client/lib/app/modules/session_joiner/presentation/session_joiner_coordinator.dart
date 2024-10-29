// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
part 'session_joiner_coordinator.g.dart';

class SessionJoinerCoordinator = _SessionJoinerCoordinatorBase
    with _$SessionJoinerCoordinator;

abstract class _SessionJoinerCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionJoinerWidgetsCoordinator widgets;
  final SwipeDetector swipe;
  final TapDetector tap;
  @override
  final CaptureScreen captureScreen;
  final SessionStartersLogicCoordinator logic;
  final SessionPresenceCoordinator presence;

  _SessionJoinerCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.presence,
    required this.swipe,
    required this.logic,
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
  }

  @observable
  bool isNavigatingAway = false;

  @action
  toggleIsNavigatingAway() => isNavigatingAway = !isNavigatingAway;

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    logic.listenToSessionActivation();
    await captureScreen(SessionJoinerConstants.sessionJoiner);
  }

  initReactors() {
    disposers.add(swipeReactor());
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
        widgets.setIsDisconnected(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        widgets.setIsDisconnected(true);
      },
    ));
    disposers.add(tapReactor());
    disposers.add(qrCodeScannerReactor());
    disposers.add(hasFoundTheSessionReactor());
  }

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) => onSwipe(p0));

  qrCodeScannerReactor() =>
      reaction((p0) => widgets.qrScanner.mostRecentScannedUID, (p0) async {
        if (p0.isNotEmpty) {
          await logic.join(p0);
          widgets.qrScanner.resetMostRecentScannedUID();
        }
      });

  hasFoundTheSessionReactor() =>
      reaction((p0) => logic.hasFoundNokhteSession, (p0) async {
        if (p0) {
          widgets.enterSession();
          setDisableAllTouchFeedback(true);
        }
      });

  @action
  onSwipe(GestureDirections direction) {
    if (!isNavigatingAway) {
      switch (direction) {
        case GestureDirections.up:
          ifTouchIsNotDisabled(() {
            if (!logic.hasFoundNokhteSession) {
              widgets.onSwipeUp();
            }
          });
        default:
          break;
      }
    }
  }

  tapReactor() => reaction((p0) => tap.tapCount, (p0) {
        ifTouchIsNotDisabled(() {
          widgets.onTap();
        });
      });

  deconstructor() async {
    await logic.dispose();
    widgets.dispose();
    dispose();
  }
}
