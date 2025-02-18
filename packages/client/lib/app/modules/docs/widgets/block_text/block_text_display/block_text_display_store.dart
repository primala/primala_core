// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';
part 'block_text_display_store.g.dart';

class BlockTextDisplayStore = _BlockTextDisplayStoreBase
    with _$BlockTextDisplayStore;

abstract class _BlockTextDisplayStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final BlockTextFieldsStore blockTextFields;

  _BlockTextDisplayStoreBase({
    required this.blockTextFields,
  });

  @action
  constructor() {
    scrollController = ScrollController();
    disposers.add(focusReactor());
  }

  @observable
  int timerCount = 0;

  @observable
  ObservableList<double> swipeProgresses = ObservableList<double>();

  @action
  setSwipeProgress(double val, int index) => swipeProgresses[index] = val;

  ScrollController scrollController = ScrollController();

  @observable
  int contentIdToDelete = -1;

  @action
  setItemIdToDelete(int value) => contentIdToDelete = value;

  @action
  onEdit(ContentBlockEntity item) {
    blockTextFields.setCurrentlySelectedContentId(item.id);
    blockTextFields.setMode(BlockTextFieldMode.editing);
    blockTextFields.controller.text = item.content;
    blockTextFields.focusNode.requestFocus();
    Timer(Seconds.get(0, milli: 500), () {
      blockTextFields.changeBlockType(item.type);
    });
  }

  @action
  onParentSelected(int itemId) {
    blockTextFields.blur.init(end: const Duration(milliseconds: 300));
    setControl(Control.stop);
    blockTextFields.setCurrentlySelectedBlock(getBlockFromId(itemId));
    blockTextFields.setCurrentlySelectedParentId(itemId);
    blockTextFields.focusNode.requestFocus();
  }

  ContentBlockEntity getBlockFromId(int id) =>
      content.firstWhere((element) => element.id == id);

  @observable
  ObservableList<ContentBlockEntity> content =
      ObservableList<ContentBlockEntity>();

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

  focusReactor() => reaction((p0) => blockTextFields.isFocused, (p0) {
        if (p0) {
          if (currentlySelectedParentIdIndex == -1) {
            Timer.periodic(const Duration(milliseconds: 200), (timer) {
              timerCount++;
              if (timerCount > 4) {
                timer.cancel();
                timerCount = 0;
                return;
              }
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            });
          }
        }
      });

  @computed
  int get currentlySelectedParentIdIndex {
    int temp = -1;
    for (int i = 0; i < content.length; i++) {
      if (content[i].id == blockTextFields.currentlySelectedParentId) {
        temp = i;
      }
    }
    return temp;
  }
}
