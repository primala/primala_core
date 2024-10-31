// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_collaboration_greeter_widgets_coordinator.g.dart';

class SessionCollaborationGreeterWidgetsCoordinator = _SessionCollaborationGreeterWidgetsCoordinatorBase
    with _$SessionCollaborationGreeterWidgetsCoordinator;

abstract class _SessionCollaborationGreeterWidgetsCoordinatorBase
    with Store, SessionRouter, BaseWidgetsCoordinator {
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  final TouchRippleStore touchRipple;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionCollaborationGreeterWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.wifiDisconnectOverlay,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.touchRipple,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
    primarySmartText.setMessagesData(SessionLists.collaborationGreeterPrimary);
    secondarySmartText.setMessagesData(SessionLists.singleTapToConfirm);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
  }

  @observable
  bool isFirstTap = true;

  @action
  onTap({
    required Offset tapPosition,
    required SessionScreenTypes phoneType,
  }) async {
    if (isFirstTap) {
      touchRipple.onTap(tapPosition);
      initTransition(phoneType);
      primarySmartText.startRotatingText(isResuming: true);
      secondarySmartText.startRotatingText(isResuming: true);
      isFirstTap = false;
    }
  }

  @action
  onCollaboratorLeft() {
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
  }

  @action
  onCollaboratorJoined() {
    primarySmartText.setWidgetVisibility(primarySmartText.pastShowWidget);
    secondarySmartText.setWidgetVisibility(secondarySmartText.pastShowWidget);
  }
}
