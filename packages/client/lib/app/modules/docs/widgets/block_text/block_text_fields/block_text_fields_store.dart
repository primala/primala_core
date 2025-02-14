// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';
part 'block_text_fields_store.g.dart';

class BlockTextFieldsStore = _BlockTextFieldsStoreBase
    with _$BlockTextFieldsStore;

abstract class _BlockTextFieldsStoreBase extends BaseWidgetStore
    with Store, BlockTextFieldMovies {
  _BlockTextFieldsStoreBase() {
    setBlockType(ContentBlockType.purpose);
    setIconMovie(getExpandingIcons(blockIcons));
    setMovie(getTextFieldTransition(
      ContentBlockType.purpose,
      ContentBlockType.purpose,
    ));
  }
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @observable
  bool isFocused = false;

  @observable
  bool isExpanded = false;

  @observable
  BlockTextFieldMode mode = BlockTextFieldMode.adding;

  @observable
  int currentlySelectedParentId = -1;

  @observable
  int currentlySelectedContentId = -1;

  @observable
  int characterCount = 0;

  @observable
  GlobalKey textFieldKey = GlobalKey();

  @observable
  double textFieldHeight = 97.0;

  @observable
  MovieStatus iconMovieStatus = MovieStatus.idle;

  @action
  setIconMovieStatus(MovieStatus value) => iconMovieStatus = value;

  @action
  updateTextFieldHeight() {
    final RenderObject? renderBox =
        textFieldKey.currentContext?.findRenderObject();
    if (renderBox != null) {
      if (movieStatus == MovieStatus.finished) {
        setControl(Control.stop);
      }
      textFieldHeight = (renderBox.semanticBounds.height) + 77;
    }
  }

  @action
  onChange(String value) => characterCount = value.length;

  @action
  setMode(BlockTextFieldMode value) => mode = value;

  @action
  reset() {
    setMode(BlockTextFieldMode.adding);
    controller.clear();
    currentTextContent = '';
    focusNode.unfocus();
    Timer(Seconds.get(0, milli: 1), () {
      updateTextFieldHeight();
    });
    characterCount = 0;
    setCurrentlySelectedParentId(-1);
    setCurrentlySelectedContentId(-1);
  }

  @action
  setCurrentlySelectedParentId(int value) => currentlySelectedParentId = value;

  @action
  setCurrentlySelectedContentId(int value) =>
      currentlySelectedContentId = value;

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
  setIsFocused(bool value) => isFocused = value;

  constructor() {
    setControl(Control.stop);
    setIconMovie(getExpandingIcons(blockIcons));
    setMovie(getTextFieldTransition(
      blockType,
      blockType,
    ));
    controller = TextEditingController();
    focusNode = FocusNode();

    controller.clear();
    focusNode.addListener(() {
      setIsFocused(focusNode.hasFocus);
      if (!focusNode.hasFocus) {
        setCurrentlySelectedParentId(-1);
        setCurrentlySelectedContentId(-1);
      }
    });
    controller.addListener(() {
      updateTextFieldHeight();
    });
  }

  @action
  onSubmit() {
    if (controller.text.trim().isNotEmpty &&
        currentTextContent != controller.text) {
      currentTextContent = controller.text;
      submissionCount++;
    } else {
      reset();
    }
    // focusNode.unfocus();
  }

  @action
  dispose() {
    controller.dispose();
    focusNode.dispose();
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
        setIconMovieStatus(MovieStatus.inProgress);
        setIconControl(Control.playReverse);
        setIsExpanded(false);
      } else {
        setIconMovieStatus(MovieStatus.inProgress);
        setIsExpanded(true);
        setIconMovie(getExpandingIcons(blockIcons));
        setIconControl(Control.playFromStart);
      }
      if (movieStatus == MovieStatus.finished) {
        setControl(Control.stop);
      }
    } else {
      if (isExpanded) {
        setIconMovieStatus(MovieStatus.inProgress);
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
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playFromStart);
    setBlockType(newType);
    Timer(Seconds.get(0, milli: 300), () {
      setMovieStatus(MovieStatus.finished);
      setControl(Control.stop);
    });
  }
}
