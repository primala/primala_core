// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/clean_up_sessions/clean_up_sessions.dart';
import 'package:nokhte/app/core/modules/clean_up_sessions/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/constants/constants.dart';
part 'quick_actions_router_coordinator.g.dart';

class QuickActionsRouterCoordinator = _QuickActionsRouterCoordinatorBase
    with _$QuickActionsRouterCoordinator;

abstract class _QuickActionsRouterCoordinatorBase
    with Store, EnRoute, EnRouteRouter, BaseCoordinator, Reactions {
  final QuickActionsRouterWidgetsCoordinator widgets;
  @override
  final CaptureScreen captureScreen;
  final UserInformationCoordinator userInfo;
  final CleanUpSessionsCoordinator cleanUpSessions;

  _QuickActionsRouterCoordinatorBase({
    required this.cleanUpSessions,
    required this.widgets,
    required this.userInfo,
    required this.captureScreen,
  }) {
    initEnRouteActions();
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.preconstructor();
    final args = Modular.args.data[HomeConstants.QUICK_ACTIONS_ROUTE];
    if (args != SessionConstants.lobby) {
      await cleanUpSessions(const NoParams());
    }
    await userInfo.checkIfVersionIsUpToDate();

    if (userInfo.isOnMostRecentVersion) {
      widgets.constructor();
    } else {
      widgets.needsToUpdateConstructor();
    }
    initReactors();
  }

  initReactors() {
    // disposers.add(widgets.beachWavesMovieStatusReactor(onAnimationComplete));
  }

  deconstructor() {
    dispose();
  }
}
