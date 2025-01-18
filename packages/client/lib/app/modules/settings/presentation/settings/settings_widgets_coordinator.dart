// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/auth/constants/constants.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte_backend/types/types.dart';
part 'settings_widgets_coordinator.g.dart';

class SettingsWidgetsCoordinator = _SettingsWidgetsCoordinatorBase
    with _$SettingsWidgetsCoordinator;

abstract class _SettingsWidgetsCoordinatorBase
    with Store, Reactions, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  final SettingsLayoutStore settingsLayout;
  final BackButtonStore backButton;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _SettingsWidgetsCoordinatorBase({
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.settingsLayout,
    required this.backButton,
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
  });

  @action
  constructor() {
    // navigationCaratThisonCarouselsType(NavigationCarouselsType.settings);
    settingsLayout.setWidgetVisibility(false);

    beachWaves.setMovieMode(BeachWaveMovieModes.anyToSky);
    beachWaves.currentStore.reverseMovie(
      DurationAndGradient(
        duration: Seconds.get(1),
        gradient: WaterColorsAndStops.invertedDeepSeaWater,
      ),
    );
    primarySmartText.setMessagesData(SettingsLists.header);
    secondarySmartText.setMessagesData(SettingsLists.question);
    primarySmartText.startRotatingText();
    secondarySmartText.startRotatingText();
    disposers.add(beachWavesMovieStatusReactor());
    disposers.add(backButtonTapReactor());
  }

  @action
  setUserInformation(UserInformationEntity user) {
    settingsLayout.setFullName(user.fullName);
    settingsLayout.setWidgetVisibility(true);
  }

  @action
  onYes(Function onTap) async {
    if (backButton.showWidget) {
      backButton.setWidgetVisibility(false);
      primarySmartText.setWidgetVisibility(false);
      settingsLayout.setWidgetVisibility(false);
      secondarySmartText.setWidgetVisibility(false);
      beachWaves.setMovieMode(BeachWaveMovieModes.anyToBlackOut);
      beachWaves.currentStore.initMovie(DurationAndGradient(
        duration: Seconds.get(1),
        gradient: WaterColorsAndStops.invertedDeepSeaWater,
      ));
      await onTap();
    }
  }

  @action
  onNo() async {
    if (backButton.showWidget) {
      backButton.setWidgetVisibility(false);
      primarySmartText.setWidgetVisibility(false);
      secondarySmartText.setWidgetVisibility(false);
      settingsLayout.setWidgetVisibility(false);
      beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
      beachWaves.currentStore.initMovie(
        const AnyToOnShoreParams(
          startingColors: WaterColorsAndStops.invertedDeepSeaWater,
        ),
      );
    }
  }

  backButtonTapReactor() => reaction((p0) => backButton.tapCount, (p0) {
        onNo();
      });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
            Modular.to.navigate(HomeConstants.home);
          } else if (beachWaves.movieMode ==
              BeachWaveMovieModes.anyToBlackOut) {
            Modular.to.navigate(AuthConstants.greeter);
          }
        }
      });
}
