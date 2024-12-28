// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:simple_animations/simple_animations.dart';
part 'block_text_fields_store.g.dart';

class BlockTextFieldsStore = _BlockTextFieldsStoreBase
    with _$BlockTextFieldsStore;

abstract class _BlockTextFieldsStoreBase extends BaseWidgetStore
    with Store, BlockTextFieldMovies {
  //
  late TextEditingController controller;
  late FocusNode focusNode;

  @observable
  bool isFocused = false;

  @observable
  bool isExpanded = false;

  @observable
  ContentBlockType blockType = ContentBlockType.purpose;

  @observable
  ObservableList<ContentBlockType> blockIcons =
      ObservableList<ContentBlockType>.of([
    ContentBlockType.quotation,
    ContentBlockType.question,
    ContentBlockType.idea,
    ContentBlockType.conclusion,
    ContentBlockType.purpose,
  ]);

  @observable
  MovieTween iconMovie = MovieTween();

  @observable
  Control iconControl = Control.stop;

  @observable
  String currentTextContent = '';

  @observable
  int submissionCount = 0;

  @action
  setIconMovie(MovieTween value) => iconMovie = value;

  @action
  setIconControl(Control value) => iconControl = value;

  @action
  setIsExpanded(bool value) => isExpanded = value;

  @action
  setisFocused(bool value) => isFocused = value;

  constructor(TextEditingController controller, FocusNode focusNode) {
    setControl(Control.stop);
    setMovie(getTextFieldTransition(
      ContentBlockType.purpose,
      ContentBlockType.purpose,
    ));
    setBlockType(ContentBlockType.purpose);
    setIconMovie(getExpandingIcons(blockIcons));

    this.controller = controller;
    this.focusNode = focusNode;
    this.focusNode.addListener(() {
      setisFocused(focusNode.hasFocus);
    });
  }

  @action
  onSubmit() {
    currentTextContent = controller.text;
    controller.clear();
    focusNode.unfocus();
    submissionCount++;
  }

  @action
  setBlockType(ContentBlockType typeToMove) {
    blockType = typeToMove;
    blockIcons.remove(typeToMove);
    blockIcons.add(typeToMove);
  }

  onTap(ContentBlockType newType) {
    if (blockType == newType) {
      if (isExpanded) {
        setIconControl(Control.playReverse);
        setIsExpanded(false);
      } else {
        setIsExpanded(true);
        setIconMovie(getExpandingIcons(blockIcons));
        setIconControl(Control.playFromStart);
      }
      setControl(Control.stop);
    } else {
      if (isExpanded) {
        changeBlockType(newType);
        setIconControl(Control.playReverse);
        setIsExpanded(false);
      }
    }
  }

  changeBlockType(ContentBlockType newType) {
    setMovie(getTextFieldTransition(
      blockType,
      newType,
    ));
    setControl(Control.playFromStart);
    setBlockType(newType);
  }

  String getAssetPath(ContentBlockType type) {
    return 'assets/blocks/${type.name}_icon.png';
  }
}
