// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'session_playlists_widgets_coordinator.g.dart';

class SessionPlaylistsWidgetsCoordinator = _SessionPlaylistsWidgetsCoordinatorBase
    with _$SessionPlaylistsWidgetsCoordinator;

abstract class _SessionPlaylistsWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final NavigationMenuStore navigationMenu;
  final SmartTextStore headerText;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final BeachWavesStore beachWaves;

  _SessionPlaylistsWidgetsCoordinatorBase({
    required this.navigationMenu,
    required this.headerText,
    required this.wifiDisconnectOverlay,
  }) : beachWaves = navigationMenu.beachWaves {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    navigationMenu.setNavigationMenuType(NavigationMenuType.sessionPlaylists);
    beachWaves.setMovieMode(BeachWaveMovieModes.deepSeaToBorealis);
    headerText.setMessagesData(PresetsLists.playlistsHeader);
    headerText.startRotatingText();
  }
}
