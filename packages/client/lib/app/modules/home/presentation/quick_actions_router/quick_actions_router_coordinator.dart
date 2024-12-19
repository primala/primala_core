// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'quick_actions_router_coordinator.g.dart';

class QuickActionsRouterCoordinator = _QuickActionsRouterCoordinatorBase
    with _$QuickActionsRouterCoordinator;

abstract class _QuickActionsRouterCoordinatorBase
    with Store, EnRoute, EnRouteRouter, BaseCoordinator, Reactions {
  final QuickActionsRouterWidgetsCoordinator widgets;
  @override
  final CaptureScreen captureScreen;
  final UserInformationCoordinator userInfo;
  final CleanUpCollaborationArtifactsCoordinator cleanUpCollaborationArtifacts;

  _QuickActionsRouterCoordinatorBase({
    required this.cleanUpCollaborationArtifacts,
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
    await cleanUpCollaborationArtifacts(const NoParams());
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
