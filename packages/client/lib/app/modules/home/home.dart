import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'home.dart';
export 'constants/constants.dart';
export 'presentation/presentation.dart';
export 'domain/domain.dart';
export 'data/data.dart';
export 'widgets/widgets.dart';
import 'home_widgets_module.dart';
import 'home_logic_module.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        HomeWidgetsModule(),
        CleanUpCollaborationArtifactsModule(),
        UserInformationModule(),
        LegacyConnectivityModule(),
        PosthogModule(),
        StorageLogicModule(),
        HomeLogicModule(),
      ];
  @override
  binds(i) {
    i.add<HomeScreenRootRouterCoordinator>(
      () => HomeScreenRootRouterCoordinator(
        cleanUpCollaborationArtifacts:
            Modular.get<CleanUpCollaborationArtifactsCoordinator>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        widgets: Modular.get<HomeScreenRootRouterWidgetsCoordinator>(),
      ),
    );
    i.add<QuickActionsRouterCoordinator>(
      () => QuickActionsRouterCoordinator(
        cleanUpCollaborationArtifacts:
            Modular.get<CleanUpCollaborationArtifactsCoordinator>(),
        widgets: Modular.get<QuickActionsRouterWidgetsCoordinator>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );

    i.add<SessionStarterCoordinator>(
      () => SessionStarterCoordinator(
        homeLogic: Modular.get<HomeLogicCoordinator>(),
        storageLogic: Modular.get<StorageLogicCoordinator>(),
        widgets: Modular.get<SessionStarterWidgetsCoordinator>(),
      ),
    );

    i.add<HomeCoordinator>(
      () => HomeCoordinator(
        tap: TapDetector(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<HomeWidgetsCoordinator>(),
        logic: Modular.get<HomeLogicCoordinator>(),
      ),
    );
    i.add<NeedsUpdateCoordinator>(
      () => NeedsUpdateCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<NeedsUpdateWidgetsCoordinator>(),
      ),
    );
    i.add<HomeEntryCoordinator>(
      () => HomeEntryCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<HomeEntryWidgetsCoordinator>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      HomeConstants.relativeRouter,
      transition: TransitionType.noTransition,
      child: (context) => HomeScreenRootRouterScreen(
        coordinator: Modular.get<HomeScreenRootRouterCoordinator>(),
      ),
    );

    r.child(
      HomeConstants.relativeSessionStarter,
      transition: TransitionType.noTransition,
      child: (context) => SessionStarterScreen(
        coordinator: Modular.get<SessionStarterCoordinator>(),
      ),
    );

    r.child(
      HomeConstants.relativeQuickActionsRouter,
      transition: TransitionType.noTransition,
      child: (context) => QuickActionsRouterScreen(
        coordinator: Modular.get<QuickActionsRouterCoordinator>(),
      ),
    );
    r.child(
      HomeConstants.relativeHome,
      transition: TransitionType.noTransition,
      child: (context) => HomeScreen(
        coordinator: Modular.get<HomeCoordinator>(),
      ),
    );
    r.child(
      HomeConstants.relativeEntry,
      transition: TransitionType.noTransition,
      child: (context) => HomeEntryScreen(
        coordinator: Modular.get<HomeEntryCoordinator>(),
      ),
    );
    r.child(
      HomeConstants.relativeNeedsToUpdate,
      transition: TransitionType.noTransition,
      child: (context) => NeedsUpdateScreen(
        coordinator: Modular.get<NeedsUpdateCoordinator>(),
      ),
    );
  }
}
