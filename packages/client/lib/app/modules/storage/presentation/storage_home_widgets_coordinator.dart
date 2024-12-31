// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
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

  @action
  constructor() {
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
  }

  @observable
  bool canTap = false;

  groupDisplayReactor() => reaction((p0) => groupDisplay.tapCount, (p0) {
        groupRegistration.setWidgetVisibility(true);
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

  queueCreationReactor(Function onCreated) =>
      reaction((p0) => queueCreationModal.modalIsVisible, (p0) async {
        if (p0) {
          await onCreated();
        }
      });

  sessionContentReactor(Function(AddContentParams params) onSubmit) =>
      reaction((p0) => queueCreationModal.blockTextFields.submissionCount,
          (p0) async {
        final params =
            queueCreationModal.blockTextDisplay.blockTextFields.currentParams;
        await onSubmit(params);
        queueCreationModal.blockTextDisplay.blockTextFields.resetParams();
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
          (p0) =>
              groupDisplayModal.groupDisplayQueueCard.currentlySelectedIndex,
          (p0) async {
        final params = groupDisplayModal.groupDisplayQueueCard.queueUIDToDelete;
        await onSubmit(params);
      });

  sessionDeletionReactor(Function(String params) onSubmit) => reaction(
          (p0) =>
              groupDisplayModal.groupDisplaySessionCard.currentlySelectedIndex,
          (p0) async {
        final params =
            groupDisplayModal.groupDisplaySessionCard.sessionUIDToDelete;
        await onSubmit(params);
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
