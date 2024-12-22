// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:simple_animations/simple_animations.dart';
part 'session_starter_widgets_coordinator.g.dart';

class SessionStarterWidgetsCoordinator = _SessionStarterWidgetsCoordinatorBase
    with _$SessionStarterWidgetsCoordinator;

abstract class _SessionStarterWidgetsCoordinatorBase
    with Store, Reactions, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  final NavigationCarouselsStore navigationCarousels;
  final SessionStarterDropdownStore sessionStarterDropdown;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _SessionStarterWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.navigationCarousels,
    required this.sessionStarterDropdown,
  }) : beachWaves = navigationCarousels.beachWaves;

  @action
  constructor() {
    navigationCarousels
        .setNavigationCarouselsType(NavigationCarouselsType.sessionStarter);

    beachWaves.currentStore.setControl(Control.stop);
  }

  @action
  onGroupsReceived(ObservableList<GroupInformationEntity> groups) {
    sessionStarterDropdown.setGroups(groups);
  }
}
