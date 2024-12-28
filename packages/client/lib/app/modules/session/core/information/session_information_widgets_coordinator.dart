// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_information_widgets_coordinator.g.dart';

class SessionInformationWidgetsCoordinator = _SessionInformationWidgetsCoordinatorBase
    with _$SessionInformationWidgetsCoordinator;

abstract class _SessionInformationWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final BeachWavesStore beachWaves;
  final TintStore tint;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionInformationWidgetsCoordinatorBase({
    required this.beachWaves,
    required this.tint,
    required this.wifiDisconnectOverlay,
  }) {
    initBaseWidgetsCoordinatorActions();
    tint.startAtEnd();
  }

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
  }

  @observable
  bool isFirstTap = true;

  @action
  onClose() {
    if (isFirstTap) {
      tint.initMovie(const NoParams());
      isFirstTap = false;
      Timer(Seconds.get(1), () {
        Modular.to.navigate(SessionConstants.soloHybrid);
      });
    }
  }
}
