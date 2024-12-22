// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'home_entry_coordinator.g.dart';

class HomeEntryCoordinator = _HomeEntryCoordinatorBase
    with _$HomeEntryCoordinator;

abstract class _HomeEntryCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        HomeScreenRouter,
        BaseCoordinator,
        Reactions {
  final HomeEntryWidgetsCoordinator widgets;

  @override
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;

  _HomeEntryCoordinatorBase({
    required this.widgets,
    required this.userInfo,
    required this.captureScreen,
  }) {
    initEnRouteActions();
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    initReactors();
    widgets.constructor();
    await userInfo.checkIfVersionIsUpToDate();
  }

  initReactors() {
    disposers.add(widgets.beachWavesMovieStatusReactor(onAnimationComplete));
  }

  deconstructor() {
    dispose();
  }
}
