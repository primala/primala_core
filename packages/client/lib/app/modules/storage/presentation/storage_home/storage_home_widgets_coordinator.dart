// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_home_widgets_coordinator.g.dart';

class StorageHomeWidgetsCoordinator = _StorageHomeWidgetsCoordinatorBase
    with _$StorageHomeWidgetsCoordinator;

abstract class _StorageHomeWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final BeachWavesStore beachWaves;
  final SmartTextStore headerText;
  final BackButtonStore backButton;
  final NokhteBlurStore blur;
  final GroupDisplayStore groupDisplay;
  final GroupRegistrationStore groupRegistration;
  final QueueCreationModalStore queueCreationModal;
  final GroupDisplayModalStore groupDisplayModal;
  final GroupDisplayCollaboratorCardStore groupDisplayCollaboratorCard;

  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  _StorageHomeWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.headerText,
    required this.groupDisplay,
    required this.groupRegistration,
    required this.backButton,
    required this.blur,
  })  : groupDisplayModal = groupDisplay.groupDisplayModal,
        groupDisplayCollaboratorCard =
            groupDisplay.groupDisplayModal.groupDisplayCollaboratorCard,
        queueCreationModal = groupDisplay.groupDisplayModal.queueCreationModal {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    backButton.setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 1), () {
      backButton.setWidgetVisibility(true);
    });

    headerText.setMessagesData(StorageLists.homeHeader);
    headerText.startRotatingText();
    beachWaves.setMovieMode(BeachWaveMovieModes.skyToHalfAndHalf);
    initReactors();
  }

  @action
  onGroupsReceived(ObservableList<GroupInformationEntity> groups) {
    groupDisplay.onGroupsReceived(groups);
  }

  initReactors() {
    disposers.add(backButtonReactor());
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

  queueCreationReactor(Function(CreateQueueParams params) onSubmit) =>
      reaction((p0) => queueCreationModal.queueSubmissionCount, (p0) async {
        if (queueCreationModal.queueItems.isEmpty ||
            queueCreationModal.queueTitleController.text.isEmpty) return;
        final params = CreateQueueParams(
          groupId: groupDisplayModal.currentlySelectedGroup.groupUID,
          content: queueCreationModal.queueItems,
          title: queueCreationModal.queueTitleController.text,
        );
        await onSubmit(params);
        queueCreationModal.dispose();
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

  backButtonReactor() => reaction((p0) => backButton.tapCount, (p0) {
        if (backButton.showWidget) {
          backButton.setWidgetVisibility(false);
          headerText.setWidgetVisibility(false);
          groupDisplay.setWidgetVisibility(false);
          Timer(Seconds.get(1), () {
            beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
            beachWaves.currentStore.initMovie(
              const AnyToOnShoreParams(
                startingColors: WaterColorsAndStops.sky,
              ),
            );
          });
        }
      });
}
