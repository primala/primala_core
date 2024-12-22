// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'session_starter_coordinator.g.dart';

class SessionStarterCoordinator = _SessionStarterCoordinatorBase
    with _$SessionStarterCoordinator;

abstract class _SessionStarterCoordinatorBase with Store, Reactions {
  final SessionStarterWidgetsCoordinator widgets;
  final StorageLogicCoordinator storageLogic;
  final HomeLogicCoordinator homeLogic;

  _SessionStarterCoordinatorBase({
    required this.widgets,
    required this.storageLogic,
    required this.homeLogic,
  });

  @action
  constructor() async {
    widgets.constructor();
    disposers.add(groupReactor());
    disposers.add(sessionStartReactor());
    await storageLogic.getGroups();
  }

  groupReactor() => reaction(
        (p0) => storageLogic.state,
        (p0) {
          if (storageLogic.state == StoreState.loading) return;
          widgets.onGroupsReceived(storageLogic.groups);
        },
      );

  sessionStartReactor() => reaction(
        (p0) => widgets.sessionStarterDropdown.tapCount,
        (p0) async {
          if (p0 == 1) {
            await homeLogic.initializeSession(InitializeSessionParams(
              groupUID: widgets.sessionStarterDropdown.groupUID,
              queueUID: widgets.sessionStarterDropdown.queueUID,
            ));
            Modular.to.navigate(
              HomeConstants.quickActionsRouter,
              arguments: {
                HomeConstants.QUICK_ACTIONS_ROUTE: SessionConstants.lobby,
              },
            );
          }
        },
      );
}
