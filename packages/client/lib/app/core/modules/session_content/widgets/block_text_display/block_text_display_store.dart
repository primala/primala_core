// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';
part 'block_text_display_store.g.dart';

class BlockTextDisplayStore = _BlockTextDisplayStoreBase
    with _$BlockTextDisplayStore;

abstract class _BlockTextDisplayStoreBase extends BaseWidgetStore with Store {
  final BlockTextFieldsStore blockTextFields;

  _BlockTextDisplayStoreBase({
    required this.blockTextFields,
  });

  @observable
  ObservableList<double> swipeProgresses = ObservableList<double>();

  @action
  setSwipeProgress(double val, int index) => swipeProgresses[index] = val;

  @observable
  int contentIdToDelete = -1;

  @action
  setItemUIDToDelete(int value) => contentIdToDelete = value;

  @action
  onEdit(ContentBlockEntity item) {
    blockTextFields.setCurrentlySelectedContentId(item.id);
    blockTextFields.setMode(BlockTextFieldMode.editing);
    blockTextFields.controller.text = item.content;
    blockTextFields.focusNode.requestFocus();
    Timer(Seconds.get(0, milli: 200), () {
      blockTextFields.updateTextFieldHeight();
    });
    Timer(Seconds.get(0, milli: 500), () {
      blockTextFields.changeBlockType(item.type);
    });
    //
  }

  @observable
  ObservableList<ContentBlockEntity> content =
      ObservableList<ContentBlockEntity>();

  @action
  onParentSelected(int itemId) {
    blockTextFields.setControl(Control.stop);
    blockTextFields.setCurrentlySelectedParentId(itemId);
    blockTextFields.focusNode.requestFocus();
  }

  @action
  setContent(ObservableList<ContentBlockEntity> newContent) {
    content = newContent;
    swipeProgresses =
        ObservableList<double>.of(List.generate(content.length, (index) => 0));
  }

  @action
  clear() {
    content = ObservableList<ContentBlockEntity>();
  }

  @action
  onSubmit() {
    blockTextFields.onSubmit();
  }
}
