// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_information_coordinator.g.dart';

class SessionInformationCoordinator = _SessionInformationCoordinatorBase
    with _$SessionInformationCoordinator;

abstract class _SessionInformationCoordinatorBase
    with Store, BaseCoordinator, Reactions, SessionPresence {
  final SessionInformationWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionMetadataStore sessionMetadata;
  final CaptureNokhteSessionStart captureStart;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionInformationCoordinatorBase({
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
    widgets.constructor(sessionMetadata.presetEntity);
    initReactors();
    await captureScreen(SessionConstants.information);
    widgets.setRoute(
      sessionMetadata.presetType == PresetTypes.collaborative
          ? SessionConstants.soloHybrid
          : SessionConstants.groupHybrid,
    );
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
      },
      onCollaboratorLeft: () {
        setDisableAllTouchFeedback(true);
      },
    ));
  }

  deconstructor() {
    dispose();
  }
}
