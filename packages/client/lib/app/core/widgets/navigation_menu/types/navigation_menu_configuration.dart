import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
import 'package:nokhte/app/modules/session_starters/constants/constants.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class NavigationMenuConfiguration extends Equatable {
  final NavigationMenuType type;

  late final List<ActionSliderInformation> sliderInfo;
  late final NavigationCarouselInformation carouselInfo;
  late final int startIndex;

  NavigationMenuConfiguration(this.type) {
    _initializeConfiguration();
  }

  void _initializeConfiguration() {
    switch (type) {
      case NavigationMenuType.homescreen:
        _configureHomescreen(startIndex: 1);
        break;
      case NavigationMenuType.sessionLobbyNoOneJoined:
        _configureSessionLobbyNoOneJoined();
        break;
      case NavigationMenuType.sessionLobbySomeoneJoined:
        _configureSessionLobbySomeoneJoined();
        break;
      case NavigationMenuType.inSession:
        _configureInSession();
        break;
      case NavigationMenuType.sessionPresets:
        _configureSessionLobbyNoOneJoined(startIndex: 0);
      case NavigationMenuType.sessionPlaylists:
        _configureSessionLobbyNoOneJoined(startIndex: 2);
      case NavigationMenuType.settings:
        _configureHomescreen(startIndex: 0);
      case NavigationMenuType.storage:
        _configureHomescreen(startIndex: 2);
    }
  }

  void _configureHomescreen({
    int startIndex = 1,
  }) {
    sliderInfo = [
      _createSliderItem('assets/qr_code_icon.png', 'Start Session',
          () => _navigateQuickActions(SessionStarterConstants.sessionStarter)),
      _createSliderItem('assets/camera_icon.png', 'Join Session',
          () => _navigateQuickActions(SessionJoinerConstants.sessionJoiner)),
    ];

    carouselInfo = _createCarouselInfo([
      startIndex == 0
          ? GradientConfig.empty()
          : ColorAndStop.toGradientConfig(
              WaterColorsAndStops.invertedDeeperBlue),
      startIndex == 1
          ? GradientConfig.empty()
          : ColorAndStop.toGradientConfig(WaterColorsAndStops.onShoreWater),
      startIndex == 2
          ? GradientConfig.empty()
          : ColorAndStop.toGradientConfig(WaterColorsAndStops.sky),
    ], [
      'settings',
      'home',
      'storage'
    ], [
      SettingsConstants.settings,
      HomeConstants.entry,
      StorageConstants.home,
    ]);

    this.startIndex = startIndex;
  }

  void _configureSessionLobbyNoOneJoined({
    int startIndex = 1,
  }) {
    sliderInfo = [
      _createSliderItem('assets/home_beach_icon.png', 'Home Screen',
          () => _navigateQuickActions(HomeConstants.home)),
    ];

    carouselInfo = _createCarouselInfo([
      startIndex == 0
          ? GradientConfig.empty()
          : ColorAndStop.toGradientConfig(
              WaterColorsAndStops.invertedDeeperBlue),
      startIndex == 1
          ? GradientConfig.empty()
          : ColorAndStop.toGradientConfig(WaterColorsAndStops.deepSeaWater),
      ColorAndStop.toGradientConfig(WaterColorsAndStops.playlistColorway),
    ], [
      "session",
      "starter",
      "playlist"
    ], [
      SessionConstants.presets,
      SessionConstants.lobby,
      SessionConstants.playlists,
    ]);

    this.startIndex = startIndex;
  }

  void _configureSessionLobbySomeoneJoined() {
    sliderInfo = [];

    carouselInfo = _createCarouselInfo([
      ColorAndStop.toGradientConfig(WaterColorsAndStops.invertedDeeperBlue),
      GradientConfig.empty(),
      ColorAndStop.toGradientConfig(WaterColorsAndStops.playlistColorway),
    ], [
      "presets",
      "starter",
      "playlist"
    ], [
      SessionConstants.presets,
      SessionConstants.lobby,
      SessionConstants.lobby,
    ]);

    startIndex = 1;
  }

  void _configureInSession() {
    sliderInfo = [
      _createSliderItem(
          'assets/session_information_icon.png',
          'Session Information',
          () => _navigateQuickActions(SessionConstants.information)),
      _createSliderItem('assets/end_session_icon.png', 'End Session',
          () => _navigateQuickActions(SessionConstants.exit)),
    ];

    carouselInfo = _createCarouselInfo([
      GradientConfig.empty(),
      GradientConfig.empty(),
      GradientConfig.empty(),
    ], [
      "settings",
      "home",
      "broadcast"
    ], [
      SettingsConstants.settings,
      HomeConstants.home,
      StorageConstants.home,
    ]);

    startIndex = 1;
  }

  // Helper method to create slider items
  ActionSliderInformation _createSliderItem(
      String assetPath, String sliderText, Function callback) {
    return ActionSliderInformation(
      assetPath: assetPath,
      sliderText: sliderText,
      callback: callback,
    );
  }

  // Helper method to create carousel info
  NavigationCarouselInformation _createCarouselInfo(
      List<GradientConfig> gradients,
      List<String> labels,
      List<String> routes) {
    return NavigationCarouselInformation(
      gradients: gradients,
      labels: labels,
      routes: routes,
    );
  }

  // Helper method to navigate quick actions
  void _navigateQuickActions(String route) {
    Modular.to.navigate(
      HomeConstants.quickActionsRouter,
      arguments: {
        HomeConstants.QUICK_ACTIONS_ROUTE: route,
      },
    );
  }

  @override
  List<Object?> get props => [
        sliderInfo,
        carouselInfo,
        type,
        startIndex,
      ];
}
