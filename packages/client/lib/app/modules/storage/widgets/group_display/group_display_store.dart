// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_store.g.dart';

class GroupDisplayStore = _GroupDisplayStoreBase with _$GroupDisplayStore;

abstract class _GroupDisplayStoreBase extends BaseWidgetStore with Store {
  final NokhteBlurStore blur;
  final GroupDisplayModalStore groupDisplayModal;

  _GroupDisplayStoreBase({
    required this.blur,
    required this.groupDisplayModal,
  });

  late BuildContext buildContext;
  late AnimationController animationController;

  constructor(context, controller) {
    if (showWidget) {
      buildContext = context;
      animationController = controller;
      setWidgetVisibility(false);
    }
  }

  @action
  onGroupsReceived(List<GroupInformationEntity> groups) {
    this.groups = ObservableList.of(groups);
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
  String groupUIDToDelete = '';

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

  void showGroupDetailsModal(GroupInformationEntity selectedGroup) {
    if (showModal) return;
    groupDisplayModal.setCurrentlySelectedGroup(selectedGroup);

    blur.init(end: Seconds.get(0, milli: 200));
    showModalBottomSheet(
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(36),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.2),
      context: buildContext,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: .91,
        initialChildSize: .9,
        minChildSize: .7,
        expand: false,
        builder: (context, scrollController) => Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Observer(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: GroupDisplayModal(
                      store: groupDisplayModal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      groupDisplayModal.resetValues();
      blur.reverse();
      setShowModal(false);
    });
  }
}
