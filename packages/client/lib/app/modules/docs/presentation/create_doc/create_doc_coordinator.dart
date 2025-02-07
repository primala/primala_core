// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents/documents.dart';
part 'create_doc_coordinator.g.dart';

class CreateDocCoordinator = _CreateDocCoordinatorBase
    with _$CreateDocCoordinator;

abstract class _CreateDocCoordinatorBase with Store, BaseMobxLogic {
  final DocsContract contract;
  final ActiveGroup activeGroup;

  _CreateDocCoordinatorBase({
    required this.contract,
    required this.activeGroup,
  });

  @observable
  String title = '';

  @action
  setTitle(String title) => this.title = title;

  @observable
  String spotlightTextContent = '';

  @action
  setSpotlightTextContent(String value) => spotlightTextContent = value;

  @observable
  ContentBlockType selectedBlockType = ContentBlockType.none;

  @action
  setBlockType(ContentBlockType type) => selectedBlockType = type;

  @action
  submit() async {
    final res = await contract.insertDocument(params);
    res.fold((failure) {
      errorUpdater(failure);
    }, (status) {
      Modular.to.pop();
    });
  }

  @computed
  InsertDocumentParams get params => InsertDocumentParams(
        documentTitle: title,
        groupId: activeGroup.groupId,
        spotlightMessage: spotlightTextContent,
        contentBlockType: selectedBlockType,
      );

  @computed
  bool get canSubmit =>
      title.isNotEmpty &&
      spotlightTextContent.isNotEmpty &&
      selectedBlockType != ContentBlockType.none;
}
