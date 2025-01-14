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
    initReactors();
    await storageLogic.getGroups();
  }

  initReactors() {
    disposers.add(groupReactor());
    disposers.add(sessionStartReactor());
    disposers.add(selectedGroupReactor());
    disposers.add(dormantSessionsReactor());
  }

  groupReactor() => reaction(
        (p0) => storageLogic.state,
        (p0) {
          if (storageLogic.state == StoreState.loading) return;
          widgets.onGroupsReceived(storageLogic.groups);
        },
      );

  selectedGroupReactor() => reaction(
        (p0) => widgets.sessionStarterDropdown.groupUID,
        (p0) async {
          if (p0.isEmpty) return;
          await storageLogic.listenToSessions(-1);
          // if (storageLogic.selectedGroup == null) return;
          // widgets.onGroupSelected(storageLogic.selectedGroup!);
        },
      );

  dormantSessionsReactor() => reaction(
        (p0) => storageLogic.dormantSessions,
        (p0) {
          if (p0.isEmpty) return;
          widgets.sessionStarterDropdown.setAvailableQueues(p0);
          // if (storageLogic.state == StoreState.loading) return;
          // widgets.onDormantSessionsReceived(storageLogic.dormantSessions);
        },
      );

  sessionStartReactor() => reaction(
        (p0) => widgets.sessionStarterDropdown.tapCount,
        (p0) async {
          if (p0 == 1) {
            await homeLogic.initializeSession();
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
