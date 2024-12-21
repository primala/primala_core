import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

class NavigationCarouselsConfiguration extends Equatable {
  final NavigationCarouselsType type;
  late final List<GradientConfig> gradients;
  late final List<String> labels;
  late final List<String> routes;
  late final int startIndex;
  late final List<NavigationCarouselsSectionDetails> sections;

  NavigationCarouselsConfiguration(this.type) {
    _initializeConfiguration();
  }

  void _initializeConfiguration() {
    switch (type) {
      case NavigationCarouselsType.homescreen:
        _configureHomescreen(startIndex: 1);
        break;
      case NavigationCarouselsType.sessionLobbyNoOneJoined:
        _configureSessionLobbyNoOneJoined();
        break;
      case NavigationCarouselsType.sessionLobbySomeoneJoined:
        _configureSessionLobbySomeoneJoined();
        break;
      case NavigationCarouselsType.inSession:
        _configureInSession();
        break;
      case NavigationCarouselsType.sessionPresets:
        _configureSessionLobbyNoOneJoined(startIndex: 0);
      case NavigationCarouselsType.sessionPlaylists:
        _configureSessionLobbyNoOneJoined(startIndex: 2, excludeSliders: true);
      case NavigationCarouselsType.sessionStarter:
        _configureHomescreen(startIndex: 0);
      case NavigationCarouselsType.storage:
        _configureHomescreen(startIndex: 2);
    }
  }

  void _configureHomescreen({
    int startIndex = 1,
  }) {
    _createCarouselInfo(
      [
        ColorAndStop.toGradientConfig(WaterColorsAndStops.invertedDeeperBlue),
        GradientConfig.empty(),
        ColorAndStop.toGradientConfig(WaterColorsAndStops.sky),
      ],
      ['sessions', 'collaborators', 'groups'],
      [
        HomeConstants.sessionStarter,
        HomeConstants.home,
        StorageConstants.home,
      ],
      startIndex == 1
          ? [
              NavigationCarouselsSectionDetails(
                NavigationCarouselsSectionTypes.cameraIcon,
              ),
              NavigationCarouselsSectionDetails(
                NavigationCarouselsSectionTypes.qrCodeIcon,
              ),
              NavigationCarouselsSectionDetails(
                NavigationCarouselsSectionTypes.queueIcon,
              ),
            ]
          : [],
    );

    this.startIndex = startIndex;
  }

  void _configureSessionLobbyNoOneJoined({
    int startIndex = 1,
    bool excludeSliders = false,
  }) {
    _createCarouselInfo(
      [
        startIndex == 0
            ? GradientConfig.empty()
            : ColorAndStop.toGradientConfig(
                WaterColorsAndStops.invertedDeeperBlue),
        startIndex == 1
            ? GradientConfig.empty()
            : ColorAndStop.toGradientConfig(WaterColorsAndStops.deepSeaWater),
        ColorAndStop.toGradientConfig(WaterColorsAndStops.playlistColorway),
      ],
      ["session", "starter", "playlist"],
      [
        SessionConstants.presets,
        SessionConstants.lobby,
        SessionConstants.playlists,
      ],
      [],
    );

    this.startIndex = startIndex;
  }

  void _configureSessionLobbySomeoneJoined() {
    _createCarouselInfo(
      [
        ColorAndStop.toGradientConfig(WaterColorsAndStops.invertedDeeperBlue),
        GradientConfig.empty(),
        ColorAndStop.toGradientConfig(WaterColorsAndStops.playlistColorway),
      ],
      ["presets", "starter", "playlist"],
      [
        SessionConstants.presets,
        SessionConstants.lobby,
        SessionConstants.lobby,
      ],
      [],
    );

    startIndex = 1;
  }

  void _configureInSession() {
    _createCarouselInfo(
      [
        GradientConfig.empty(),
        GradientConfig.empty(),
        GradientConfig.empty(),
      ],
      ["settings", "home", "broadcast"],
      [
        SettingsConstants.settings,
        HomeConstants.home,
        StorageConstants.home,
      ],
      [],
    );

    startIndex = 1;
  }

  _createCarouselInfo(
    List<GradientConfig> gradients,
    List<String> labels,
    List<String> routes,
    List<NavigationCarouselsSectionDetails> sections,
  ) {
    this.gradients = gradients;
    this.labels = labels;
    this.routes = routes;
    this.sections = sections;
  }

  @override
  List<Object?> get props => [
        gradients,
        labels,
        routes,
        sections,
        type,
        startIndex,
      ];
}
