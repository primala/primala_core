// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// import 'dart:async';
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/gyroscopic/mobx/gyroscopic_coordinator.dart';
import 'package:nokhte/app/core/modules/posthog/constants/constants.dart';
import 'package:nokhte/app/core/modules/session_presence/session_presence.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/irl_nokhte_session/irl_nokhte_session.dart';
part 'irl_nokhte_session_group_greeter_coordinator.g.dart';

class IrlNokhteSessionGroupGreeterCoordinator = _IrlNokhteSessionGroupGreeterCoordinatorBase
    with _$IrlNokhteSessionGroupGreeterCoordinator;

abstract class _IrlNokhteSessionGroupGreeterCoordinatorBase
    extends BaseCoordinator with Store {
  final DecidePhoneRole decidePhoneRoleLogic;
  final IrlNokhteSessionGroupGreeterWidgetsCoordinator widgets;
  final TapDetector tap;
  final SessionPresenceCoordinator presence;
  final GetSessionMetadataStore sessionMetadata;
  final GyroscopicCoordinator gyroscopic;

  _IrlNokhteSessionGroupGreeterCoordinatorBase({
    required super.captureScreen,
    required this.widgets,
    required this.decidePhoneRoleLogic,
    required this.tap,
    required this.presence,
    required this.gyroscopic,
  }) : sessionMetadata = presence.getSessionMetadataStore;

  @observable
  Stopwatch stopwatch = Stopwatch();

  @observable
  bool isNavigatingAway = false;

  @observable
  IrlNokhteSessionPhoneRole phoneRole = IrlNokhteSessionPhoneRole.initial;

  @computed
  String get pathIntoSession => phoneRole == IrlNokhteSessionPhoneRole.talking
      ? '/irl_nokhte_session/speaking_instructions'
      : '/irl_nokhte_session/notes_instructions';

  @action
  constructor() async {
    print("group greeter!!!");
    widgets.constructor();
    initReactors();
    await captureScreen(Screens.nokhteSessionGreeter);
    await gyroscopic.checkIfDeviceHasGyroscope();
    await decidePhoneRole();
  }

  @action
  onInactive() async {
    await presence
        .updateOnlineStatus(UpdatePresencePropertyParams.userNegative());
  }

  @action
  onResumed() async {
    await presence
        .updateOnlineStatus(UpdatePresencePropertyParams.userAffirmative());
    if (presence.getSessionMetadataStore.everyoneIsOnline) {
      presence.incidentsOverlayStore.onCollaboratorJoined();
    }
  }

  @action
  initReactors() {
    deviceGyroscopeStatusReactor();
    widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
        // widgets.onResumed();
      },
      onDisconnected: () {
        // widgets.onInactive();
        setDisableAllTouchFeedback(true);
      },
    );
    presence.initReactors(
      onCollaboratorJoined: () {
        setDisableAllTouchFeedback(false);
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () {
        setDisableAllTouchFeedback(true);
        widgets.onCollaboratorLeft();
      },
    );
    tapReactor();
    rippleCompletionStatusReactor();
    collaboratorPhaseReactor();
    userPhaseReactor();
  }

  @action
  decidePhoneRole() async {
    final res = await decidePhoneRoleLogic(NoParams());
    res.fold((failure) => errorUpdater(failure),
        (assignedRole) => phoneRole = assignedRole);
  }

  collaboratorPhaseReactor() =>
      reaction((p0) => sessionMetadata.currentPhases, (p0) {
        if (sessionMetadata.canMoveIntoInstructions &&
            widgets.touchRipple.movieStatus != MovieStatus.inProgress &&
            tap.tapCount.isGreaterThan(0)) {
          widgets.invisiblizePrimarySmartText();
          isNavigatingAway = true;
          Modular.to.navigate(pathIntoSession);
        }
      });

  userPhaseReactor() => reaction((p0) => sessionMetadata.userPhase, (p0) {
        if (sessionMetadata.userPhase == 1.0) {
          Timer(Seconds.get(10), () {
            if (!isNavigatingAway) {
              widgets.onTenSecondLapse();
            }
          });
        }
      });

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(() async {
          widgets.onTap(
            tap.currentTapPosition,
            onFinalTap: () async => await presence.updateCurrentPhase(1),
          );
        }),
      );

  rippleCompletionStatusReactor() =>
      reaction((p0) => widgets.touchRipple.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            presence.getSessionMetadataStore.canMoveIntoInstructions) {
          isNavigatingAway = true;
          Modular.to.navigate(pathIntoSession);
        }
      });

  deviceGyroscopeStatusReactor() =>
      reaction((p0) => gyroscopic.deviceHasGyroscope, (p0) async {
        if (!p0) {
          await presence.updateHasGyroscope(false);
        }
      });
}
