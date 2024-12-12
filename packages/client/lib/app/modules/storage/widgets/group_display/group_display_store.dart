// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_store.g.dart';

class GroupDisplayStore = _GroupDisplayStoreBase with _$GroupDisplayStore;

abstract class _GroupDisplayStoreBase extends BaseWidgetStore with Store {
  final GroupDisplayModalStore groupDisplayModal;

  _GroupDisplayStoreBase({
    required this.groupDisplayModal,
  });

  late BuildContext buildContext;
  late AnimationController animationController;

  constructor(context) {
    if (showWidget) {
      buildContext = context;
      setWidgetVisibility(false);
    }
  }

  @action
  onGroupsReceived(List<GroupInformationEntity> groups) {
    print('where you going here');
    if (groups.isNotEmpty) {
      this.groups = ObservableList.of(groups);
      groupDisplayModal.groupDisplayQueueCard.setQueues(
        groups[currentlySelectedIndex].queues,
      );
    }
    setWidgetVisibility(true);
  }

  @observable
  ObservableList<GroupInformationEntity> groups = ObservableList.of([]);

  @observable
  bool isDragging = false;

  @observable
  bool showModal = false;

  @observable
  int successfulDragsCount = 0;

  @observable
  int currentlySelectedIndex = 0;

  @observable
  String groupUIDToDelete = '';

  @action
  setCurrentlySelectedIndex(int value) => currentlySelectedIndex = value;

  @action
  setIsDragging(bool value) => isDragging = value;

  @action
  setShowModal(bool value) => showModal = value;

  @action
  onDragAccepted(GroupInformationEntity group) {
    successfulDragsCount++;
    groupUIDToDelete = group.groupUID;
    setIsDragging(false);
  }

  @action
  onAddButtonTap() {
    if (isDragging || !showWidget) return;
    incrementTapCount();
    setWidgetVisibility(false);
  }
}
