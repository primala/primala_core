// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:simple_animations/simple_animations.dart';
part 'storage_home_widgets_coordinator.g.dart';

class StorageHomeWidgetsCoordinator = _StorageHomeWidgetsCoordinatorBase
    with _$StorageHomeWidgetsCoordinator;

abstract class _StorageHomeWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final NavigationCarouselsStore navigationCarousels;
  final NokhteBlurStore blur;
  final GroupDisplayStore groupDisplay;
  final GroupRegistrationStore groupRegistration;
  final QueueCreationModalStore queueCreationModal;
  final GroupDisplayModalStore groupDisplayModal;
  final GroupDisplayCollaboratorCardStore groupDisplayCollaboratorCard;

  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _StorageHomeWidgetsCoordinatorBase({
    required this.navigationCarousels,
    required this.wifiDisconnectOverlay,
    required this.groupDisplay,
    required this.groupRegistration,
    required this.blur,
  })  : beachWaves = navigationCarousels.beachWaves,
        groupDisplayModal = groupDisplay.groupDisplayModal,
        groupDisplayCollaboratorCard =
            groupDisplay.groupDisplayModal.groupDisplayCollaboratorCard,
        queueCreationModal = groupDisplay.groupDisplayModal.queueCreationModal {
    initBaseWidgetsCoordinatorActions();
  }

  late BuildContext buildContext;

  @action
  constructor(BuildContext buildContext) {
    this.buildContext = buildContext;
    beachWaves.currentStore.setControl(Control.stop);
    navigationCarousels.setNavigationCarouselsType(
      NavigationCarouselsType.storage,
    );
    initReactors();
  }

  @action
  onGroupsReceived(ObservableList<GroupInformationEntity> groups) {
    groupDisplay.onGroupsReceived(groups);
  }

  initReactors() {
    disposers.add(beachWavesMovieStatusReactor());
    disposers.add(groupDisplayReactor());
    disposers.add(userButtonTapReactor());
  }

  @observable
  bool canTap = false;

  groupDisplayReactor() => reaction((p0) => groupDisplay.tapCount, (p0) {
        groupRegistration.setWidgetVisibility(true);
      });

  userButtonTapReactor() =>
      reaction((p0) => groupDisplay.userButtonTapCount, (p0) {
        //
        print('we are tapping ');
        if (p0 == 1) {
          groupDisplay.setWidgetVisibility(false);
          navigationCarousels.setWidgetVisibility(false);
          Timer(Seconds.get(1), () {
            Modular.to.navigate(SettingsConstants.settings);
          });
        }
      });

  groupRegistrationReactor(Function onSubmit) =>
      reaction((p0) => groupRegistration.submissionCount, (p0) async {
        await onSubmit();
        groupDisplay.setWidgetVisibility(true);
        Timer(Seconds.get(1), () {
          groupRegistration.reset();
        });
      });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
          dispose();
          Modular.to.navigate(HomeConstants.home);
        }
      });

  queueCreationReactor(Function onCreated, Function onClosed) =>
      reaction((p0) => queueCreationModal.modalIsVisible, (p0) async {
        if (queueCreationModal.isCreatingNewQueue) {
          if (p0) {
            await onCreated();
          } else {
            await onClosed();
          }
        } else {
          if (!p0) {
            await onClosed();
          }
          //
        }
      });

  sessionOpenReactor(Function(String sessionUID) onSelected) => reaction(
          (p0) => groupDisplayModal.groupDisplaySessionCard.sessionUIDToOpen,
          (p0) async {
        if (p0.isEmpty) return;
        await onSelected(p0);
        queueCreationModal.setIsEditable(false);
        queueCreationModal.showModal(buildContext);
        groupDisplayModal.groupDisplaySessionCard.setSessionUIDToOpen('');
      });

  queueOpenReactor(Function(String sessionUID) onSelected) =>
      reaction((p0) => groupDisplayModal.groupDisplayQueueCard.sessionUIDToOpen,
          (p0) async {
        if (p0.isEmpty) return;
        await onSelected(p0);
        queueCreationModal.setIsEditable(true);
        queueCreationModal.showModal(buildContext);
        groupDisplayModal.groupDisplayQueueCard.setSessionUIDToOpen('');
      });

  groupModalOpenStatusReactor(
          Function(String groupUID) onOpened, Function onClosed) =>
      reaction((p0) => groupDisplayModal.currentlySelectedGroup.groupUID,
          (p0) async {
        if (p0.isNotEmpty) {
          await onOpened(p0);
        } else {
          await onClosed();
        }
      });

  sessionContentReactor({
    required Function(AddContentParams params) onAdd,
    required Function(UpdateContentParams params) onUpdate,
  }) =>
      reaction((p0) => queueCreationModal.blockTextFields.submissionCount,
          (p0) async {
        if (queueCreationModal.blockTextFields.mode ==
            BlockTextFieldMode.adding) {
          await onAdd(queueCreationModal
              .blockTextDisplay.blockTextFields.addContentParams);
        } else {
          await onUpdate(queueCreationModal
              .blockTextDisplay.blockTextFields.updateContentParams);
        }
        queueCreationModal.blockTextDisplay.blockTextFields.resetParams();
      });

  contentDeletionReactor(Function(String params) onDelete) =>
      reaction((p0) => queueCreationModal.blockTextDisplay.itemUIDToDelete,
          (p0) async {
        if (p0.isEmpty) return;
        await onDelete(p0);
      });

  membershipAdditionReactor(
          Function(UpdateGroupMemberParams params) onSubmit) =>
      reaction((p0) => groupDisplayCollaboratorCard.membersToAdd, (p0) async {
        final peopleToAdd = groupDisplayCollaboratorCard.membersToAdd;
        final params = UpdateGroupMemberParams(
          groupId: groupDisplayModal.currentlySelectedGroup.groupUID,
          members: peopleToAdd,
          isAdding: true,
        );
        if (peopleToAdd.isNotEmpty) {
          await onSubmit(params);
        }
      });

  queueDeletionReactor(Function(String params) onSubmit) => reaction(
          (p0) => groupDisplayModal.groupDisplayQueueCard.sessionUIDToDelete,
          (p0) async {
        // final params = groupDisplayModal.groupDisplayQueueCard.queueUIDToDelete;
        await onSubmit(p0);
      });

  sessionDeletionReactor(Function(String params) onSubmit) => reaction(
          (p0) => groupDisplayModal.groupDisplaySessionCard.sessionUIDToDelete,
          (p0) async {
        // final params =
        //     groupDisplayModal.groupDisplaySessionCard.sessionUIDToDelete;
        // print('deleting session $params');
        await onSubmit(p0);
      });

  membershipRemovalReactor(Function(UpdateGroupMemberParams params) onSubmit) =>
      reaction((p0) => groupDisplayCollaboratorCard.membersToRemove,
          (p0) async {
        final peopleToRemove = groupDisplayCollaboratorCard.membersToRemove;
        final params = UpdateGroupMemberParams(
          groupId: groupDisplayModal.currentlySelectedGroup.groupUID,
          members: peopleToRemove,
          isAdding: false,
        );
        if (peopleToRemove.isNotEmpty) {
          await onSubmit(params);
        }
      });

  groupDisplayDragReactor(Function(String params) onSubmit) =>
      reaction((p0) => groupDisplay.successfulDragsCount, (p0) async {
        groupDisplay.setWidgetVisibility(false);
        final idToDelete = groupDisplay.groupUIDToDelete;
        await onSubmit(idToDelete);
      });
}
