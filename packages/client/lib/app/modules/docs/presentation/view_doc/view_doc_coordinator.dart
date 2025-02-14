// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';
part 'view_doc_coordinator.g.dart';

class ViewDocCoordinator = _ViewDocCoordinatorBase with _$ViewDocCoordinator;

abstract class _ViewDocCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic, Reactions {
  final DocsContract contract;
  final BlockTextFieldsStore blockTextFields;
  final ActiveGroup activeGroup;
  final BlockTextDisplayStore blockTextDisplay;

  _ViewDocCoordinatorBase({
    required this.contract,
    required this.activeGroup,
    required this.blockTextDisplay,
  }) : blockTextFields = blockTextDisplay.blockTextFields {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 500);

  @action
  constructor(DocumentEntity doc) async {
    dispose();
    spotlightController = TextEditingController();
    docTitleController = TextEditingController();
    setShowWidgets(false);
    this.doc = doc;
    docTitleController.text = doc.title;
    await listenToContent(documentId);
    initReactors();
  }

  @observable
  bool reactorsAreInitiated = false;

  @observable
  ObservableList<ContentBlockEntity> contentBlocks =
      ObservableList<ContentBlockEntity>();

  @observable
  ObservableStream<ContentBlocks> contentBlocksStream =
      ObservableStream<ContentBlocks>(const Stream.empty());

  @observable
  StreamSubscription contentBlocksStreamSubscription =
      const Stream.empty().listen((event) {});

  initReactors() {
    if (reactorsAreInitiated) return;
    disposers.add(spotlightTextReactor());
    disposers.add(blockTextFieldSubmissionReactor());
    disposers.add(contentToDeletionReactor());
    disposers.add(textFieldCharactersReactor());
  }

  @action
  listenToContent(int documentId) async {
    final res = await contract.listenToDocumentContent(documentId);
    res.fold((failure) => errorUpdater(failure), (stream) {
      contentBlocksStream = ObservableStream(stream);
      contentBlocksStreamSubscription = contentBlocksStream.listen((value) {
        contentBlocks = ObservableList.of(value);
        final filteredList = ObservableList.of(contentBlocks
            .where((element) => element.id != spotlightContentBlockId)
            .toList());
        if (spotlightController.text.isEmpty && spotlightText.isNotEmpty) {
          spotlightController.text = spotlightText;
        }

        blockTextDisplay.setContent(filteredList);
        setShowWidgets(true);
      });
    });
  }

  @action
  onTrashPressed() async {
    final res = await contract.deleteDocument(documentId);
    res.fold((failure) => errorUpdater(failure), (value) => onBackPress());
  }

  @action
  onBackPress() {
    Modular.to.pop();
    Timer(Seconds.get(0, milli: 200), () {
      title = '';
      contentBlocks = ObservableList<ContentBlockEntity>();
    });
  }

  @observable
  String title = '';

  @action
  setTitleVal(String value) => title = value;

  @observable
  int textFieldCharactersCount = 0;

  ScrollController scrollController = ScrollController();

  @observable
  DocumentEntity doc = DocumentEntity.initial();

  TextEditingController docTitleController = TextEditingController();

  TextEditingController spotlightController = TextEditingController();

  @observable
  bool titleEditWasExternal = false;

  @action
  setTitleEditWasExternal(bool value) => titleEditWasExternal = value;

  @observable
  bool spotlightEditWasExternal = false;

  @action
  setSpotlightEditWasExternal(bool value) => spotlightEditWasExternal = value;

  @action
  onTitleChanged(String value) {
    if (titleEditWasExternal) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () async {
      await contract.updateDocumentTitle(
        UpdateDocumentTitleParams(
          documentId: documentId,
          title: value,
        ),
      );
    });
  }

  @action
  onSpotlightTextChanged(String value) {
    if (spotlightEditWasExternal) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () async {
      await contract.updateContent(
        UpdateContentParams(
          content: value,
          contentId: spotlightContentBlockId,
          contentBlockType: spotlightContentBlock.type,
        ),
      );
    });
  }

  @action
  onBlockTypeChanged(ContentBlockType type) async {
    await contract.updateContent(
      UpdateContentParams(
        content: spotlightController.text,
        contentId: spotlightContentBlockId,
        contentBlockType: type,
      ),
    );
  }

  @action
  setTitle(String value) {
    setText(
      value,
      docTitleController,
      onEditInitiated: () {
        setTitleVal(value);
        return setTitleEditWasExternal(true);
      },
      onEditCompleted: () => setTitleEditWasExternal(false),
    );
  }

  @action
  setSpotlightText(String value) {
    setText(
      value,
      spotlightController,
      onEditInitiated: () => setSpotlightEditWasExternal(true),
      onEditCompleted: () => setSpotlightEditWasExternal(false),
    );
  }

  @action
  setText(String value, TextEditingController controller,
      {required Function onEditInitiated, required Function onEditCompleted}) {
    if (value == controller.text) return;
    onEditInitiated();

    final currentPosition = controller.selection.baseOffset;
    final oldText = controller.text;
    final wasAtEnd = currentPosition == oldText.length;

    int firstDiff = 0;
    while (firstDiff < oldText.length &&
        firstDiff < value.length &&
        oldText[firstDiff] == value[firstDiff]) {
      firstDiff++;
    }

    int oldTextSuffix = oldText.length - 1;
    int newTextSuffix = value.length - 1;
    while (oldTextSuffix >= firstDiff &&
        newTextSuffix >= firstDiff &&
        oldText[oldTextSuffix] == value[newTextSuffix]) {
      oldTextSuffix--;
      newTextSuffix--;
    }

    controller.text = value;

    if (currentPosition != -1) {
      int newPosition;
      if (wasAtEnd) {
        newPosition = value.length;
      } else if (currentPosition <= firstDiff) {
        newPosition = currentPosition;
      } else if (currentPosition > oldTextSuffix + 1) {
        final lengthDifference = value.length - oldText.length;
        newPosition = currentPosition + lengthDifference;
      } else {
        newPosition = newTextSuffix + 1;
      }

      newPosition = newPosition.clamp(0, value.length);

      controller.selection =
          TextSelection.fromPosition(TextPosition(offset: newPosition));
    }

    onEditCompleted();
  }

  spotlightTextReactor() => reaction((p0) => spotlightText, (p0) {
        setSpotlightText(p0);
      });

  blockTextFieldSubmissionReactor() =>
      reaction((p0) => blockTextFields.submissionCount, (p0) async {
        if (characterCount > 2000) return;
        if (blockTextFields.mode == BlockTextFieldMode.adding) {
          await contract.addContent(addContentParams);
        } else {
          await contract.updateContent(updateContentParams);
        }
        blockTextFields.reset();
      });

  textFieldCharactersReactor() =>
      reaction((p0) => blockTextFields.currentTextContent, (p0) {
        textFieldCharactersCount = p0.length;
      });

  isDuplicate(String text) {
    if (contentBlocks.isEmpty) return false;
    return contentBlocks.any((element) => element.content == text);
  }

  @override
  @action
  dispose() async {
    reactorsAreInitiated = false;
    // scrollController.dispose();
    // docTitleController.dispose();
    // spotlightController.dispose();
    super.dispose();
    await contract.cancelContentStream();
    await contentBlocksStreamSubscription.cancel();
    _debounceTimer?.cancel();
  }

  contentToDeletionReactor() =>
      reaction((p0) => blockTextDisplay.contentIdToDelete, (p0) async {
        if (p0 == -1) return;
        await contract.deleteContent(p0);
      });

  @computed
  int get documentId => doc.id;

  @computed
  int get spotlightContentBlockId => doc.spotlightContentId;

  @computed
  ContentBlockEntity get spotlightContentBlock {
    if (contentBlocks.isNotEmpty) {
      final index =
          contentBlocks.indexWhere((e) => e.id == spotlightContentBlockId);
      return contentBlocks[index];
    } else {
      return ContentBlockEntity.initial();
    }
  }

  @computed
  int get characterCount {
    int count = blockTextFields.characterCount;
    for (var element in contentBlocks) {
      count += element.content.length;
    }
    return count - spotlightText.length;
  }

  @computed
  String get spotlightText => spotlightContentBlock.content;

  @computed
  String get currentFocus {
    if (contentBlocks.isEmpty) {
      return '';
    } else {
      return contentBlocks
          .where((element) => element.numberOfParents == 0)
          .last
          .content;
    }
  }

  @computed
  AddContentParams get addContentParams => AddContentParams(
        content: blockTextFields.currentTextContent,
        groupId: activeGroup.groupId,
        documentId: documentId,
        contentBlockType: blockTextFields.blockType,
        parentId: blockTextFields.currentlySelectedParentId,
      );

  @computed
  UpdateContentParams get updateContentParams => UpdateContentParams(
        content: blockTextFields.currentTextContent,
        contentId: blockTextFields.currentlySelectedContentId,
        contentBlockType: blockTextFields.blockType,
      );
}
