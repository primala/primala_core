import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';

mixin BaseExitCoordinator on BaseCoordinator {
  SwipeDetector get swipe;
  SessionPresenceCoordinator get presence;
  SessionMetadataStore get sessionMetadata;

  final _blockUserPhaseReactor = Observable(false);
  bool get blockUserPhaseReactor => _blockUserPhaseReactor.value;
  _setBlockUserPhaseReactor(bool value) => _blockUserPhaseReactor.value = value;
  Action actionSetBlockUserPhaseReactor = Action(() {});

  setBlockUserPhaseReactor(bool value) {
    actionSetBlockUserPhaseReactor([value]);
  }

  initBaseExitCoordinatorActions() {
    actionSetBlockUserPhaseReactor = Action(_setBlockUserPhaseReactor);
  }

  swipeReactor({required Function onSwipeDown}) =>
      reaction((p0) => swipe.directionsType, (p0) {
        switch (p0) {
          case GestureDirections.down:
            ifTouchIsNotDisabled(() async {
              await presence.updateUserStatus(SessionUserStatus.online);
              onSwipeDown();
              setDisableAllTouchFeedback(true);
            });
          default:
            break;
        }
      });

  userPhaseReactor({
    required Function initWrapUp,
  }) =>
      reaction((p0) => sessionMetadata.collaboratorStatuses.toString(),
          (p0) async {
        if (sessionMetadata.collaboratorStatuses
            .every((element) => element == SessionUserStatus.readyToLeave)) {
          await initWrapUp();
        }
      });
}
