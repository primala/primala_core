// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'login_widgets_coordinator.g.dart';

class LoginScreenWidgetsCoordinator = _LoginScreenWidgetsCoordinatorBase
    with _$LoginScreenWidgetsCoordinator;

abstract class _LoginScreenWidgetsCoordinatorBase
    with Store, SmartTextPaddingAdjuster, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final SmartTextStore smartTextStore;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _LoginScreenWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.smartTextStore,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
  }

  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.blackOutToDrySand);
    smartTextStore.setMessagesData(LoginList.list);
    smartTextStore.startRotatingText();
  }

  @observable
  bool hasTriggeredLoginAnimation = false;

  @observable
  bool showLoginButtons = false;

  @action
  toggleHasTriggeredLoginAnimation() =>
      hasTriggeredLoginAnimation = !hasTriggeredLoginAnimation;

  @action
  onTap() {
    if (!showLoginButtons && smartTextStore.currentIndex == 1) {
      smartTextStore.startRotatingText(isResuming: true);
      showLoginButtons = true;
    }
  }

  @action
  triggerLoginAnimation() {
    smartTextStore.setWidgetVisibility(false);
    showLoginButtons = false;
    toggleHasTriggeredLoginAnimation();
    Timer(Seconds.get(0, milli: 500), () {
      beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
      beachWaves.currentStore.initMovie(
        const AnyToOnShoreParams(
          startingColors: WaterColorsAndStops.blackOut,
          endingColors: WaterColorsAndStops.onShoreWater,
        ),
      );
    });
  }

  @action
  loggedInOnResumed() {
    if (!hasTriggeredLoginAnimation) {
      triggerLoginAnimation();
    }
  }

  beachWavesReactor(Function onComplete) =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          onComplete();
        }
      });
}
