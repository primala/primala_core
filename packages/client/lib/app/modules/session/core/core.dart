import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/modules/user_metadata/user_metadata.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'duo_greeter/duo_greeter.dart';
export 'exit/exit.dart';
export './information/information.dart';
export 'group_greeter/group_greeter.dart';
export 'lobby/lobby.dart';
export './shared/shared.dart';
export 'trial_greeter/trial_greeter.dart';
export 'socratic_speaking_exit/socratic_speaking_exit.dart';
export 'collaboration_greeter/collaboration_greeter.dart';

class SessionCoreModule extends Module {
  @override
  List<Module> get imports => [
        CleanUpCollaborationArtifactsModule(),
        PosthogModule(),
        SessionLogicModule(),
        UserMetadataModule(),
        UserInformationModule(),
      ];

  @override
  void exportedBinds(i) {
    i.add<SessionInformationCoordinator>(
      () => SessionInformationCoordinator(
        captureStart: Modular.get<CaptureNokhteSessionStart>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionInformationWidgetsCoordinator>(),
      ),
    );
    i.add<SessionLobbyCoordinator>(
      () => SessionLobbyCoordinator(
        captureStart: Modular.get<CaptureNokhteSessionStart>(),
        userMetadata: Modular.get<UserMetadataCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        tap: TapDetector(),
        widgets: Modular.get<SessionLobbyWidgetsCoordinator>(),
      ),
    );
    i.add<SessionDuoGreeterCoordinator>(
      () => SessionDuoGreeterCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionDuoGreeterWidgetsCoordinator>(),
        tap: TapDetector(),
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
    i.add<SessionTrialGreeterCoordinator>(
      () => SessionTrialGreeterCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionTrialGreeterWidgetsCoordinator>(),
        tap: TapDetector(),
      ),
    );
    i.add<SessionGroupGreeterCoordinator>(
      () => SessionGroupGreeterCoordinator(
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SessionGroupGreeterWidgetsCoordinator>(),
        tap: TapDetector(),
      ),
    );
    i.add<SessionExitCoordinator>(
      () => SessionExitCoordinator(
        captureEnd: Modular.get<CaptureNokhteSessionEnd>(),
        cleanUpCollaborationArtifacts:
            Modular.get<CleanUpCollaborationArtifactsCoordinator>(),
        swipe: SwipeDetector(),
        widgets: Modular.get<SessionExitWidgetsCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );

    i.add<SocraticSpeakingExitCoordinator>(
      () => SocraticSpeakingExitCoordinator(
        swipe: SwipeDetector(),
        widgets: Modular.get<SocraticSpeakingExitWidgetsCoordinator>(),
        presence: Modular.get<SessionPresenceCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      SessionConstants.relativeSocraticSpeakingExit,
      transition: TransitionType.noTransition,
      child: (context) => SocraticSpeakingExitScreen(
        coordinator: Modular.get<SocraticSpeakingExitCoordinator>(),
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
      SessionConstants.relativeGroupGreeter,
      transition: TransitionType.noTransition,
      child: (context) => SessionGroupGreeterScreen(
        coordinator: Modular.get<SessionGroupGreeterCoordinator>(),
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
      SessionConstants.relativeTrialGreeter,
      transition: TransitionType.noTransition,
      child: (context) => SessionTrialGreeterScreen(
        coordinator: Modular.get<SessionTrialGreeterCoordinator>(),
      ),
    );
    r.child(
      SessionConstants.relativeDuoGreeter,
      transition: TransitionType.noTransition,
      child: (context) => SessionDuoGreeterScreen(
        coordinator: Modular.get<SessionDuoGreeterCoordinator>(),
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
