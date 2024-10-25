// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_exit_widgets_coordinator.g.dart';

class SessionExitWidgetsCoordinator = _SessionExitWidgetsCoordinatorBase
    with _$SessionExitWidgetsCoordinator;

abstract class _SessionExitWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseExitWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  final TintStore tint;
  @override
  final ExitStatusIndicatorStore exitStatusIndicator;
  @override
  final SmartTextStore primarySmartText;
  @override
  final SmartTextStore secondarySmartText;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final BorderGlowStore borderGlow;

  _SessionExitWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.exitStatusIndicator,
    required this.wifiDisconnectOverlay,
    required this.primarySmartText,
    required this.borderGlow,
    required this.secondarySmartText,
    required this.tint,
  }) {
    initBaseWidgetsCoordinatorActions();
    initBaseExitWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    tint.initMovie(const NoParams());
    primarySmartText.setMessagesData(SessionLists.waitingToLeave);
    secondarySmartText.setMessagesData(SessionLists.exitBottomText);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
    beachWaves.setMovieMode(
      BeachWaveMovieModes.skyToDrySand,
    );
  }

  @action
  initHomeTransition() {
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
    tint.reverseMovie(const NoParams());
    beachWaves.setMovieMode(BeachWaveMovieModes.onShoreToSky);
    beachWaves.currentStore.reverseMovie(-10.0);
    borderGlow.setWidgetVisibility(false);
  }

  @action
  onReadyToGoBack(Function onReadyToGoBack) async {
    tint.reverseMovie(const NoParams());
    exitStatusIndicator.setWidgetVisibility(false);
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
    // if (phoneRole == SessionScreenTypes.speaking ||
    //     phoneRole == SessionScreenTypes.groupHybrid ||
    //     phoneRole == SessionScreenTypes.soloHybrid) {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    beachWaves.currentStore.initMovie(const NoParams());
    // } else if (phoneRole == SessionScreenTypes.notes) {
    //   Timer(Seconds.get(1), () {
    //     Modular.to.navigate(SessionConstants.notes);
    //   });
    // }
    await onReadyToGoBack();
  }

  sessionExitStatusCompletionReactor({
    required Function onInitialized,
    required Function onReadyToGoHome,
  }) =>
      reaction((p0) => exitStatusIndicator.movieStatus, (p0) async {
        if (p0 == MovieStatus.finished) {
          if (exitStatusIndicator.movieMode == ExitStatusMovieModes.show) {
            onInitialized();
          } else if (exitStatusIndicator.movieMode ==
              ExitStatusMovieModes.complete) {
            exitStatusIndicator.setWidgetVisibility(false);
            await onReadyToGoHome();
          } else if (exitStatusIndicator.movieMode ==
              ExitStatusMovieModes.hide) {}
        }
      });

  beachWavesMovieStatusReactor({
    required Function onBackToSession,
  }) =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.onShoreToSky) {
            Modular.to.navigate(HomeConstants.home);
          } else {
            onBackToSession();
          }
        }
      });
}
