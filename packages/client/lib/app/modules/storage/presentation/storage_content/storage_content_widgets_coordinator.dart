// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_content_widgets_coordinator.g.dart';

class StorageContentWidgetsCoordinator = _StorageContentWidgetsCoordinatorBase
    with _$StorageContentWidgetsCoordinator;

abstract class _StorageContentWidgetsCoordinatorBase
    with Store, SmartTextPaddingAdjuster, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final ContentCardStore contentCard;
  final BackButtonStore backButton;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _StorageContentWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.backButton,
    required this.contentCard,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
  }

  @action
  constructor() {
    contentCard.initFadeIn();
    beachWaves.setMovieMode(BeachWaveMovieModes.drySandToSky);
    initReactors();
  }

  initReactors() {
    disposers.add(beachWavesReactor());
    disposers.add(backButtonReactor());
  }

  backButtonReactor() => reaction((p0) => backButton.tapCount, (p0) {
        if (backButton.showWidget) {
          contentCard.setWidgetVisibility(false);
          backButton.setWidgetVisibility(false);
          Timer(Seconds.get(1), () {
            beachWaves.setMovieMode(BeachWaveMovieModes.skyToDrySand);
            beachWaves.currentStore.reverseMovie(const NoParams());
          });
        }
      });

  beachWavesReactor() =>
      reaction((p0) => beachWaves.currentStore.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          Modular.to.navigate(StorageConstants.home);
        }
      });
}
