// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  final GroupDisplayCardStore groupDisplaySessionCard;
  final BlockTextDisplayStore blockTextDisplay;
  final BlockTextFieldsStore blockTextFields;

  // Text controllers
  TextEditingController queueTitleController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  // Focus nodes
  FocusNode queueTitleFocusNode = FocusNode();
  FocusNode itemFocusNode = FocusNode();
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 500);

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
  bool isEditable = false;

  @observable
  int queueSubmissionCount = 0;

  @observable
  String queueTitle = '';

  @observable
  bool isCreatingNewQueue = false;

  @observable
  bool titleEditWasExternal = false;

  @action
  void setIsCreatingNewQueue(bool value) {
    isEditable = true;
    isCreatingNewQueue = value;
  }

  @action
  setIsEditable(bool val) => isEditable = val;

  @action
  void setModalIsVisible(bool value) => modalIsVisible = value;

  @action
  void toggleSelectionMode(bool isManual) {
    isManualSelected = isManual;
  }

  @action
  onTitleChanged(String value) {
    if (titleEditWasExternal) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      queueTitle = value;
    });
  }

  @action
  setTitle(String value) {
    if (value == queueTitleController.text) return;

    titleEditWasExternal = true;
    final currentPosition = queueTitleController.selection.baseOffset;
    final oldText = queueTitleController.text;

    // Check if cursor was at the end
    final wasAtEnd = currentPosition == oldText.length;

    queueTitleController.text = value;

    if (currentPosition != -1) {
      if (wasAtEnd) {
        // If cursor was at end, move to new end
        queueTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));
      } else {
        // Keep cursor at same position if that position still exists
        final newPosition = currentPosition.clamp(0, value.length);
        queueTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: newPosition));
      }
    }

    titleEditWasExternal = false;
  }

  void showModal(BuildContext context) {
    if (modalIsVisible) return;
    setModalIsVisible(true);

    ;

    blur.init(end: Seconds.get(0, milli: 200));
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
          builder: (context, scrollController) => Observer(
              builder: (context) => QueueCreationModal(
                    blur: blur,
                    scrollController: scrollController,
                    queueTitleController: queueTitleController,
                    groupDisplaySessionCard: groupDisplaySessionCard,
                    queueTitleFocusNode: queueTitleFocusNode,
                    isCreatingNewQueue: isEditable,
                    isManualSelected: isManualSelected,
                    blockTextDisplay: blockTextDisplay,
                    queueItems: queueItems,
                    onTitleChanged: onTitleChanged,
                    toggleSelectionMode: toggleSelectionMode,
                  ))),
    ).whenComplete(() {
      blur.reverse();
      setModalIsVisible(false);
      setIsCreatingNewQueue(false);
      queueTitleController.clear();
      blockTextDisplay.clear();
      if (isEditable) {
        blockTextFields.controller.clear();
      }
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
      _debounceTimer?.cancel();

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
