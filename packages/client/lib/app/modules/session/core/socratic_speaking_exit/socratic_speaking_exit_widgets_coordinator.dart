// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'socratic_speaking_exit_widgets_coordinator.g.dart';

class SocraticSpeakingExitWidgetsCoordinator = _SocraticSpeakingExitWidgetsCoordinatorBase
    with _$SocraticSpeakingExitWidgetsCoordinator;

abstract class _SocraticSpeakingExitWidgetsCoordinatorBase
    with
        Store,
        Reactions,
        BaseWidgetsCoordinator,
        Reactions,
        BaseExitWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  @override
  final SmartTextStore primarySmartText;
  @override
  final SmartTextStore secondarySmartText;
  @override
  final ExitStatusIndicatorStore exitStatusIndicator;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _SocraticSpeakingExitWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.exitStatusIndicator,
  }) {
    initBaseWidgetsCoordinatorActions();
    initBaseExitWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    primarySmartText.setMessagesData(SessionLists.waitingToTakeFinalNote);
    primarySmartText.startRotatingText();
    secondarySmartText.setMessagesData(SessionLists.exitBottomText);
    secondarySmartText.startRotatingText();
    beachWaves.setMovieMode(BeachWaveMovieModes.orangeSandToHalfAndHalf);
    initReactors();
  }

  initReactors() {
    disposers.add(beachWavesMovieStatusReactor());
  }

  initBackToSpeaking() {
    beachWaves.setMovieMode(BeachWaveMovieModes.orangeSandToHalfAndHalf);
    beachWaves.currentStore.initMovie(const NoParams());
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
  }

  @action
  initNotesTransition() {
    beachWaves.setMovieMode(BeachWaveMovieModes.orangeSandToSky);
    beachWaves.currentStore.initMovie(const NoParams());
    primarySmartText.setWidgetVisibility(false);
    secondarySmartText.setWidgetVisibility(false);
  }

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.orangeSandToSky) {
            Modular.to.navigate(SessionConstants.notes);
          } else {
            // Modular.to.navigate(SessionConstants.speaking);
          }
        }
      });
}
