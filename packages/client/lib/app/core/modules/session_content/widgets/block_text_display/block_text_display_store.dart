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
  String itemUIDToDelete = '';

  @action
  setItemUIDToDelete(String value) => itemUIDToDelete = value;

  @action
  onEdit(SessionContentEntity item) {
    blockTextFields.setCurrentlySelectedItemUID(item.uid);
    blockTextFields.setMode(BlockTextFieldMode.editing);
    blockTextFields.controller.text = item.content;
    blockTextFields.focusNode.requestFocus();
    Timer(Seconds.get(0, milli: 200), () {
      blockTextFields.updateTextFieldHeight();
    });
    Timer(Seconds.get(0, milli: 500), () {
      blockTextFields.changeBlockType(item.blockType);
    });
    //
  }

  @observable
  ObservableList<SessionContentEntity> content =
      ObservableList<SessionContentEntity>();

  @action
  onParentSelected(String itemUID) {
    blockTextFields.setControl(Control.stop);
    blockTextFields.setCurrentlySelectedParentUID(itemUID);
    blockTextFields.focusNode.requestFocus();
  }

  @action
  setContent(ObservableList<SessionContentEntity> newContent) {
    content = newContent;
    swipeProgresses =
        ObservableList<double>.of(List.generate(content.length, (index) => 0));
  }

  @action
  clear() {
    content = ObservableList<SessionContentEntity>();
  }

  @action
  onSubmit() {
    blockTextFields.onSubmit();
  }
}
