// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_home_widgets_coordinator.g.dart';

class StorageHomeWidgetsCoordinator = _StorageHomeWidgetsCoordinatorBase
    with _$StorageHomeWidgetsCoordinator;

abstract class _StorageHomeWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final SessionCardStore sessionCard;
  final SmartTextStore headerText;
  final BackButtonStore backButton;
  final NokhteBlurStore blur;

  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _StorageHomeWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.headerText,
    required this.sessionCard,
    required this.backButton,
    required this.blur,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    sessionCard.initFadeIn();
    backButton.setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 1), () {
      backButton.setWidgetVisibility(true);
    });

    headerText.setMessagesData(StorageLists.homeHeader);
    headerText.startRotatingText();
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    initReactors();
  }

  initReactors() {
    disposers.add(backButtonReactor());
  }

  @observable
  bool canTap = false;

  @action
  onSessionCardTapped() {
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
    beachWaves.currentStore.initMovie(const NoParams());
    sessionCard.setWidgetVisibility(false);
    headerText.setWidgetVisibility(false);
  }

  deconstructor() {
    sessionCard.dispose();
    dispose();
  }

  backButtonReactor() => reaction((p0) => backButton.tapCount, (p0) {
        if (backButton.showWidget) {
          sessionCard.setWidgetVisibility(false);
          backButton.setWidgetVisibility(false);
          headerText.setWidgetVisibility(false);
          Timer(Seconds.get(1), () {
            beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
            beachWaves.currentStore.initMovie(
              const AnyToOnShoreParams(
                startingColors: WaterColorsAndStops.sky,
              ),
            );
          });
        }
      });
}
