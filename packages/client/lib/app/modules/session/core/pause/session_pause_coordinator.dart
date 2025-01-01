// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_pause_coordinator.g.dart';

class SessionPauseCoordinator = _SessionPauseCoordinatorBase
    with _$SessionPauseCoordinator;

abstract class _SessionPauseCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionPauseWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionMetadataStore sessionMetadata;
  final CaptureSessionStart captureStart;
  // @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionPauseCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
    required this.captureStart,
    required this.tap,
    required this.presence,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }

  @observable
  bool hasTapped = true;

  @action
  constructor() async {
    Timer(Seconds.get(0, milli: 1), () {
      hasTapped = false;
    });
    widgets.constructor();
    initReactors();
    await presence.dispose();
    Modular.dispose<SessionLogicModule>();
    await presence.listen();
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
    disposers.add(tapReactor());
  }

  tapReactor() => reaction((p0) => tap.tapCount, (p0) async {
        if (!hasTapped) {
          hasTapped = true;
          widgets.onTap();
          Timer(Seconds.get(1), () {
            Modular.to.navigate(SessionConstants.soloHybrid);
          });
        }
      });

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
