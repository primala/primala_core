// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_home_coordinator.g.dart';

class StorageHomeCoordinator = _StorageHomeCoordinatorBase
    with _$StorageHomeCoordinator;

abstract class _StorageHomeCoordinatorBase
    with
        Store,
        EnRoute,
        EnRouteRouter,
        BaseCoordinator,
        BaseMobxLogic,
        Reactions {
  final StorageHomeWidgetsCoordinator widgets;
  @override
  final CaptureScreen captureScreen;
  final TapDetector tap;
  final StorageLogicCoordinator storageLogic;
  final SessionContentLogicCoordinator sessionContentLogic;

  final SwipeDetector swipe;
  _StorageHomeCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
    required this.swipe,
    required this.storageLogic,
    required this.tap,
    required this.sessionContentLogic,
  }) {
    initEnRouteActions();
    initBaseCoordinatorActions();
    initBaseLogicActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await storageLogic.getGroups();
    await captureScreen(StorageConstants.home);
  }

  initReactors() {
    disposers.add(groupReactor());
    disposers.add(widgets.groupDisplayDragReactor(onGroupsDeleted));
    disposers.add(widgets.groupRegistrationReactor(onGroupCreated));
    disposers.add(widgets.queueCreationReactor(onQueueCreated));
    disposers.add(widgets.membershipAdditionReactor(onGroupMembershipUpdated));
    disposers.add(widgets.membershipRemovalReactor(onGroupMembershipUpdated));
    disposers.add(widgets.queueDeletionReactor(onQueueDeleted));
    disposers.add(widgets.sessionDeletionReactor(onSessionDeleted));
    disposers
        .add(widgets.sessionContentReactor(sessionContentLogic.addContent));
    disposers.add(sessionContentReactor());
    disposers.add(queueUIDReactor());
  }

  sessionContentReactor() =>
      reaction((p0) => sessionContentLogic.sessionContentEntity, (p0) {
        print('are you working ${p0}');
        widgets.queueCreationModal.blockTextDisplay.setContent(p0);
      });

  queueUIDReactor() => reaction((p0) => storageLogic.queueUID, (p0) async {
        await sessionContentLogic.listenToSessionContent(
          storageLogic.queueUID,
        );
      });

  @action
  onGroupCreated() async {
    await storageLogic.createNewGroup(widgets.groupRegistration.params);
    await storageLogic.getGroups();
  }

  @action
  onQueueCreated() async {
    await storageLogic.createQueue(
      widgets.groupDisplayModal.currentlySelectedGroup.groupUID,
    );
  }

  @action
  onGroupMembershipUpdated(UpdateGroupMemberParams params) async {
    await storageLogic.updateGroupMembers(params);
    await storageLogic.getGroups();
  }

  @action
  onGroupsDeleted(String params) async {
    await storageLogic.deleteGroup(params);
    await storageLogic.getGroups();
  }

  @action
  onSessionDeleted(String params) async {
    await storageLogic.deleteSession(params);
    await storageLogic.getGroups();
  }

  @action
  onQueueDeleted(String params) async {
    await storageLogic.deleteQueue(params);
    await storageLogic.getGroups();
  }

  groupReactor() => reaction(
        (p0) => storageLogic.state,
        (p0) {
          if (storageLogic.state == StoreState.loading) return;
          widgets.onGroupsReceived(storageLogic.groups);
        },
      );

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
