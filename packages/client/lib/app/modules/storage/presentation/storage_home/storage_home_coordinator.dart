// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
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

  final SwipeDetector swipe;
  _StorageHomeCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
    required this.swipe,
    required this.storageLogic,
    required this.tap,
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
  }

  @action
  onGroupCreated() async {
    await storageLogic.createNewGroup(widgets.groupRegistration.params);
    await storageLogic.getGroups();
  }

  @action
  onQueueCreated(CreateQueueParams params) async {
    await storageLogic.createQueue(params);
    await storageLogic.getGroups();
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

  // groupDisplayedDragReactor() =>
  //     reaction((p0) => widgets.groupDisplay.successfulDragsCount, (p0) async {
  //       widgets.groupDisplay.setWidgetVisibility(false);
  //       await storageLogic.deleteGroup(widgets.groupDisplay.groupUIDToDelete);
  //       await storageLogic.getGroups();
  //     });

  // queueCreationReactor() => reaction(
  //       (p0) => widgets.groupDisplay.groupDisplayModal.queueCreationModal
  //           .queueSubmissionCount,
  //       (p0) async {
  //         if (widgets.groupDisplay.groupDisplayModal.queueCreationModal
  //                 .queueItems.isEmpty ||
  //             widgets.groupDisplay.groupDisplayModal.queueCreationModal
  //                 .queueTitleController.text.isEmpty) return;
  //         final params = CreateQueueParams(
  //           groupId: widgets
  //               .groupDisplay.groupDisplayModal.currentlySelectedGroup.groupUID,
  //           content: widgets
  //               .groupDisplay.groupDisplayModal.queueCreationModal.queueItems,
  //           title: widgets.groupDisplay.groupDisplayModal.queueCreationModal
  //               .queueTitleController.text,
  //         );
  //         await storageLogic.createQueue(params);
  //         widgets.groupDisplay.groupDisplayModal.queueCreationModal.dispose();
  //         await storageLogic.getGroups();
  //       },
  //     );

  // membershipAdditionReactor() => reaction(
  //         (p0) => widgets.groupDisplay.groupDisplayModal
  //             .groupDisplayCollaboratorCard.membersToAdd, (p0) async {
  //       print('are we showing the modal yet? $p0');
  //       final peopleToAdd = widgets.groupDisplay.groupDisplayModal
  //           .groupDisplayCollaboratorCard.membersToAdd;

  //       if (peopleToAdd.isNotEmpty) {
  //         await storageLogic.updateGroupMembers(
  //           UpdateGroupMemberParams(
  //             groupId: widgets.groupDisplay.groupDisplayModal
  //                 .currentlySelectedGroup.groupUID,
  //             members: peopleToAdd,
  //             isAdding: true,
  //           ),
  //         );
  //         await storageLogic.getGroups();
  //       }
  //     });

  // membershipRemovalReactor() => reaction(
  //         (p0) => widgets.groupDisplay.groupDisplayModal
  //             .groupDisplayCollaboratorCard.membersToRemove, (p0) async {
  //       final peopleToRemove = widgets.groupDisplay.groupDisplayModal
  //           .groupDisplayCollaboratorCard.membersToRemove;

  //       if (peopleToRemove.isNotEmpty) {
  //         await storageLogic.updateGroupMembers(
  //           UpdateGroupMemberParams(
  //             groupId: widgets.groupDisplay.groupDisplayModal
  //                 .currentlySelectedGroup.groupUID,
  //             members: peopleToRemove,
  //             isAdding: false,
  //           ),
  //         );
  //       }
  //       await storageLogic.getGroups();
  //     });

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
