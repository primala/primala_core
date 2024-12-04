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
import 'package:nokhte/app/modules/login/login.dart';
part 'settings_widgets_coordinator.g.dart';

class SettingsWidgetsCoordinator = _SettingsWidgetsCoordinatorBase
    with _$SettingsWidgetsCoordinator;

abstract class _SettingsWidgetsCoordinatorBase
    with Store, Reactions, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _SettingsWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.wifiDisconnectOverlay,
  });

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.invertedDeeperBlueToDeepSea);
    primarySmartText.setMessagesData(SettingsLists.header);
    secondarySmartText.setMessagesData(SettingsLists.question);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
    disposers.add(beachWavesMovieStatusReactor());

    Timer(Seconds.get(0, milli: 1), () {
      setShowButton(true);
    });
  }

  @observable
  bool showButtons = false;

  @action
  setShowButton(bool value) => showButtons = value;

  @action
  onYes(Function onTap) async {
    if (showButtons) {
      setShowButton(false);
      primarySmartText.setWidgetVisibility(false);
      secondarySmartText.setWidgetVisibility(false);
      beachWaves.currentStore.initMovie(const NoParams());
      await onTap();
    }
  }

  @action
  onNo() async {
    if (showButtons) {
      primarySmartText.setWidgetVisibility(false);
      secondarySmartText.setWidgetVisibility(false);
      setShowButton(false);
      beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
      beachWaves.currentStore.initMovie(
        const AnyToOnShoreParams(
          startingColors: WaterColorsAndStops.deeperBlue,
        ),
      );
    }
  }

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
            Modular.to.navigate(HomeConstants.home);
          } else {
            Modular.to.navigate(LoginConstants.root);
          }
        }
      });
}
