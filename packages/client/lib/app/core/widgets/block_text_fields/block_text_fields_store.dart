// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
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
  BlockTypes blockType = BlockTypes.purpose;

  @observable
  ObservableList<BlockTypes> blockIcons = ObservableList<BlockTypes>.of([
    BlockTypes.quotation,
    BlockTypes.question,
    BlockTypes.idea,
    BlockTypes.conclusion,
    BlockTypes.purpose,
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
  toggleExpanded() => isExpanded = !isExpanded;

  @action
  setisFocused(bool value) => isFocused = value;

  constructor(TextEditingController controller, FocusNode focusNode) {
    setControl(Control.stop);
    setMovie(getTextFieldTransition(
      BlockTypes.purpose,
      BlockTypes.purpose,
    ));
    setBlockType(BlockTypes.purpose);
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
  setBlockType(BlockTypes typeToMove) {
    blockType = typeToMove;
    blockIcons.remove(typeToMove);
    blockIcons.add(typeToMove);
  }

  onTap(BlockTypes newType) {
    if (blockType == newType) {
      if (isExpanded) {
        if (iconControl != Control.stop) {
          setIconControl(Control.playReverse);
        }
        toggleExpanded();
      } else {
        toggleExpanded();
        setIconMovie(getExpandingIcons(blockIcons));
        setIconControl(Control.playFromStart);
      }
      setControl(Control.stop);
    } else {
      if (isExpanded) {
        changeBlockType(newType);
        setIconControl(Control.playReverse);
        toggleExpanded();
      }
    }
  }

  changeBlockType(BlockTypes newType) {
    setMovie(getTextFieldTransition(
      blockType,
      newType,
    ));
    setControl(Control.playFromStart);
    setBlockType(newType);
  }

  String getAssetPath(BlockTypes type) {
    return 'assets/blocks/${type.name}_icon.png';
  }

  @computed
  String get iconPath => 'assets/blocks/${blockType.name}_icon.png';

  @computed
  String get buttonPath => 'assets/blocks/${blockType.name}_send_icon.png';
}
