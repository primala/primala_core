// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'queue_creation_modal_store.g.dart';

class QueueCreationModalStore = _QueueCreationModalStoreBase
    with _$QueueCreationModalStore;

abstract class _QueueCreationModalStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final NokhteBlurStore blur;
  final GroupDisplaySessionCardStore groupDisplaySessionCard;
  final BlockTextDisplayStore blockTextDisplay;
  final BlockTextFieldsStore blockTextFields;

  // Text controllers
  TextEditingController queueTitleController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  // Focus nodes
  FocusNode queueTitleFocusNode = FocusNode();
  FocusNode itemFocusNode = FocusNode();

  @observable
  bool isManualSelected = true;

  @observable
  ObservableList<String> queueItems = ObservableList<String>();

  _QueueCreationModalStoreBase({
    required this.blur,
    required this.groupDisplaySessionCard,
    required this.blockTextDisplay,
  }) : blockTextFields = blockTextDisplay.blockTextFields;

  @observable
  bool modalIsVisible = false;

  @observable
  int queueSubmissionCount = 0;

  @observable
  String queueTitle = '';

  @action
  void setModalIsVisible(bool value) => modalIsVisible = value;

  @action
  void toggleSelectionMode(bool isManual) {
    isManualSelected = isManual;
  }

  @action
  onTitleChanged(String value) {}

  @action
  void addQueueItem() {
    if (itemController.text.trim().isNotEmpty) {
      queueItems.add(itemController.text.trim());
      itemController.clear();
    }
  }

  @action
  deleteItem(int index) => queueItems.removeAt(index);

  @action
  editItem(int index) {
    itemController.text = queueItems[index];
    queueItems.removeAt(index);
    itemFocusNode.requestFocus();
  }

  initReactors() {
    disposers.add(pastSessionMessageReactor());
  }

  pastSessionMessageReactor() =>
      reaction((p0) => groupDisplaySessionCard.currentlySelectedMessage, (p0) {
        if (queueItems.contains(p0.substring(2).trim())) return;
        queueItems.add(p0.substring(2).trim());
        // groupDisplaySessionCard.toggleSelection(groupDisplaySessionCard.)
      });

  @action
  void reorderQueueItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = queueItems.removeAt(oldIndex);
    queueItems.insert(newIndex, item);
  }

  void showModal(BuildContext context) {
    if (modalIsVisible) return;
    setModalIsVisible(true);
    blur.init(end: Seconds.get(0, milli: 200));
    initReactors();
    showModalBottomSheet(
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(36),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.5),
      context: context,
      builder: (context) => DraggableScrollableSheet(
          maxChildSize: .91,
          initialChildSize: .9,
          minChildSize: .7,
          expand: false,
          builder: (context, scrollController) => QueueCreationModal(
                blur: blur,
                scrollController: scrollController,
                queueTitleController: queueTitleController,
                groupDisplaySessionCard: groupDisplaySessionCard,
                queueTitleFocusNode: queueTitleFocusNode,
                isManualSelected: isManualSelected,
                blockTextDisplay: blockTextDisplay,
                queueItems: queueItems,
                onTitleChanged: onTitleChanged,
                toggleSelectionMode: toggleSelectionMode,
                editItem: editItem,
                deleteItem: deleteItem,
                reorderQueueItems: reorderQueueItems,
              )),
    ).whenComplete(() {
      blur.reverse();
      setModalIsVisible(false);
      dispose();
    });
  }

  // Dispose method to clean up the controllers
  @override
  @action
  void dispose() {
    if (queueTitleController.text.isEmpty || queueItems.isEmpty) return;
    queueSubmissionCount++;
    if (queueSubmissionCount.isEven) {
      queueTitleController.clear();
      itemController.clear();
      queueItems = ObservableList<String>();
    } else {
      super.dispose();
    }

    // queueTitleController.dispose();
    // itemController.dispose();
  }

  // @computed
  // String get queueTitle => queueTitleController.text.isEmpty
  //     ? 'Untitled Queue'
  //     : queueTitleController.text;
}
