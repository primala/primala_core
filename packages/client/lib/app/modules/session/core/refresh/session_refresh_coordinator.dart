// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_refresh_coordinator.g.dart';

class SessionRefreshCoordinator = _SessionRefreshCoordinatorBase
    with _$SessionRefreshCoordinator;

abstract class _SessionRefreshCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionRefreshWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionMetadataStore sessionMetadata;
  final CaptureNokhteSessionStart captureStart;
  // @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionRefreshCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
    required this.captureStart,
    required this.tap,
    required this.presence,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }

  @observable
  bool isNavigatingAway = false;

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
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
    disposers.add(sessionPresetReactor());
  }

  sessionPresetReactor() =>
      reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          Modular.to.navigate(
            sessionMetadata.presetType == PresetTypes.collaborative
                ? SessionConstants.soloHybrid
                : SessionConstants.groupHybrid,
          );
        }
      });

  deconstructor() {
    dispose();
  }
}
