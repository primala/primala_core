// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/modules/clean_up_sessions/clean_up_sessions.dart';
import 'package:nokhte/app/core/modules/quick_actions/quick_actions.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'home_screen_root_router_coordinator.g.dart';

class HomeScreenRootRouterCoordinator = _HomeScreenRootRouterCoordinatorBase
    with _$HomeScreenRootRouterCoordinator;

abstract class _HomeScreenRootRouterCoordinatorBase
    with Store, EnRoute, EnRouteRouter, HomeScreenRouter {
  final CleanUpSessionsCoordinator cleanUpSessions;
  final HomeScreenRootRouterWidgetsCoordinator widgets;
  @override
  final UserInformationCoordinator userInfo;

  @observable
  bool isConnected = true;

  @action
  setIsConnected(bool newVal) => isConnected = newVal;

  _HomeScreenRootRouterCoordinatorBase({
    required this.cleanUpSessions,
    required this.userInfo,
    required this.widgets,
  }) {
    initEnRouteActions();
    QuickActionsConstants.route(() {
      setIsRouting(true);
    });
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await cleanUpSessions(const NoParams());
    if (isConnected && !isRouting) {
      await decideAndRoute(setRoutingParams);
    }
  }

  @observable
  bool isRouting = false;

  @action
  setIsRouting(bool newVal) => isRouting = newVal;

  @action
  setRoutingParams() {
    setParams(
      ResumeOnShoreParams(
        direction: widgets.waterDirection,
        position: widgets.beachWaves.currentAnimationValues.first,
      ),
    );
  }

  initReactors() {
    widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () async {
        setIsConnected(true);
      },
      onLongReConnected: () async {
        await decideAndRoute(setParams);
        setIsConnected(true);
      },
      onDisconnected: () {
        setIsConnected(false);
      },
    );
  }
}
