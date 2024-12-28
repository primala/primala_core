import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'exit/exit.dart';
export 'information/information.dart';
export 'pause/pause.dart';
export 'lobby/lobby.dart';
export 'playlists/playlists.dart';
export './shared/shared.dart';
export 'action_slider_router/action_slider_router.dart';
export 'collaboration_greeter/collaboration_greeter.dart';

class SessionCoreModule extends Module {
  @override
  List<Module> get imports => [
        PosthogModule(),
        SessionLogicModule(),
        StorageLogicModule(),
        UserInformationModule(),
        UserInformationModule(),
      ];

  @override
  void exportedBinds(i) {
    i.add<SessionInformationCoordinator>(
      () => SessionInformationCoordinator(
        captureStart: Modular.get<CaptureSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionInformationWidgetsCoordinator>(),
      ),
    );

    i.add<SessionPlaylistsCoordinator>(
      () => SessionPlaylistsCoordinator(
        storageLogic: Modular.get<StorageLogicCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionPlaylistsWidgetsCoordinator>(),
      ),
    );

    i.add<SessionLobbyCoordinator>(
      () => SessionLobbyCoordinator(
        captureStart: Modular.get<CaptureSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionLobbyWidgetsCoordinator>(),
      ),
    );

    i.add<SessionCollaborationGreeterCoordinator>(
      () => SessionCollaborationGreeterCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionCollaborationGreeterWidgetsCoordinator>(),
        tap: TapDetector(),
      ),
    );

    i.add<SessionExitCoordinator>(
      () => SessionExitCoordinator(
        captureEnd: Modular.get<CaptureSessionEnd>(),
        swipe: SwipeDetector(),
        widgets: Modular.get<SessionExitWidgetsCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );

    i.add<ActionSliderRouterCoordinator>(
      () => ActionSliderRouterCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        widgets: Modular.get<ActionSliderRouterWidgetsCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      SessionConstants.relativeActionSliderRouter,
      transition: TransitionType.noTransition,
      child: (context) => ActionSliderRouterScreen(
        coordinator: Modular.get<ActionSliderRouterCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativePlaylists,
      transition: TransitionType.noTransition,
      child: (context) => SessionPlaylistsScreen(
        coordinator: Modular.get<SessionPlaylistsCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeInformation,
      transition: TransitionType.noTransition,
      child: (context) => SessionInformationScreen(
        coordinator: Modular.get<SessionInformationCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeLobby,
      transition: TransitionType.noTransition,
      child: (context) => SessionLobbyScreen(
        coordinator: Modular.get<SessionLobbyCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeCollaborationGreeter,
      transition: TransitionType.noTransition,
      child: (context) => SessionCollaborationGreeterScreen(
        coordinator: Modular.get<SessionCollaborationGreeterCoordinator>(),
      ),
    );

    r.child(
      SessionConstants.relativeExit,
      transition: TransitionType.noTransition,
      child: (context) => SessionExitScreen(
        coordinator: Modular.get<SessionExitCoordinator>(),
      ),
    );
  }
}
