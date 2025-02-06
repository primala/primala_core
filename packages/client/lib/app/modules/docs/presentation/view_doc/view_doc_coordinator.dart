// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
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
  }) : blockTextFields = blockTextDisplay.blockTextFields;

  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 500);

  @action
  constructor(DocumentEntity doc) async {
    this.doc = doc;
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
        blockTextDisplay.setContent(filteredList);
      });
    });
  }

  @observable
  String title = '';

  @observable
  DocumentEntity doc = DocumentEntity.initial();

  TextEditingController docTitleController = TextEditingController();

  TextEditingController spotlightController = TextEditingController();

  @observable
  bool titleEditWasExternal = false;

  @observable
  bool spotlightEditWasExternal = false;

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
    if (titleEditWasExternal) return;
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
    if (value == docTitleController.text) return;
    titleEditWasExternal = true;
    final currentPosition = docTitleController.selection.baseOffset;
    final oldText = docTitleController.text;
    final wasAtEnd = currentPosition == oldText.length;
    docTitleController.text = value;
    if (currentPosition != -1) {
      if (wasAtEnd) {
        docTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));
      } else {
        final newPosition = currentPosition.clamp(0, value.length);
        docTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: newPosition));
      }
    }
    titleEditWasExternal = false;
  }

  @action
  setSpotlightText(String value) {
    if (value == spotlightController.text) return;
    spotlightEditWasExternal = true;
    final currentPosition = spotlightController.selection.baseOffset;
    final oldText = spotlightController.text;
    final wasAtEnd = currentPosition == oldText.length;
    spotlightController.text = value;
    if (currentPosition != -1) {
      if (wasAtEnd) {
        spotlightController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));
      } else {
        final newPosition = currentPosition.clamp(0, value.length);
        spotlightController.selection =
            TextSelection.fromPosition(TextPosition(offset: newPosition));
      }
    }
    spotlightEditWasExternal = false;
  }

  spotlightTextReactor() => reaction((p0) => spotlightText, (p0) {
        setSpotlightText(p0);
      });

  blockTextFieldSubmissionReactor() =>
      reaction((p0) => blockTextFields.submissionCount, (p0) async {
        if (blockTextFields.mode == BlockTextFieldMode.adding) {
          await contract.addContent(addContentParams);
        } else {
          await contract.updateContent(updateContentParams);
        }
        blockTextFields.reset();
      });

  @override
  @action
  dispose() async {
    reactorsAreInitiated = false;
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
  int get spotlightContentBlockId => doc.id;

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
  String get spotlightText => spotlightContentBlock.content;

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
