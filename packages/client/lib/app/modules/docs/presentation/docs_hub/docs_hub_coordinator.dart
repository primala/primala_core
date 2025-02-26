// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';
part 'docs_hub_coordinator.g.dart';

class DocsHubCoordinator = _DocsHubCoordinatorBase with _$DocsHubCoordinator;

abstract class _DocsHubCoordinatorBase
    with
        Store,
        BaseWidgetsCoordinator,
        BaseCoordinator,
        BaseMobxLogic,
        Reactions {
  final DocsContract contract;
  final ActiveGroup activeGroup;
  final ViewDocCoordinator viewDocCoordinator;
  @override
  final CaptureScreen captureScreen;

  _DocsHubCoordinatorBase({
    required this.contract,
    required this.activeGroup,
    required this.viewDocCoordinator,
    required this.captureScreen,
  }) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  ObservableList<DocumentEntity> currentDocuments = ObservableList();

  @observable
  ObservableList<DocumentEntity> archivedDocuments = ObservableList();

  @observable
  int selectedDocIndex = -1;

  @observable
  bool isCurrentSelected = true;

  @observable
  ObservableStream<DocumentEntities> documentsStream =
      ObservableStream(const Stream.empty());

  @observable
  StreamSubscription documentsStreamSubscription =
      const Stream.empty().listen((event) {});

  @action
  constructor() async {
    await listenToDocuments();
    fadeInWidgets();

    disposers.add(docTitleReactor());
    await captureScreen(DocsConstants.docsHub);
  }

  @action
  setIsCurrentSelected(bool value) => isCurrentSelected = value;

  @action
  listenToDocuments() async {
    final res = await contract.listenToDocuments(activeGroup.groupId);
    res.fold((failure) => errorUpdater(failure), (stream) {
      documentsStream = ObservableStream(stream);
      documentsStreamSubscription = documentsStream.listen((event) {
        currentDocuments = ObservableList.of(
            event.where((element) => element.isArchived == false).toList());
        archivedDocuments = ObservableList.of(
            event.where((element) => element.isArchived == true).toList());
      });
    });
  }

  @action
  onDocTapped(int index) async {
    selectedDocIndex = index;
    Modular.to.push(MaterialPageRoute(
      builder: (context) {
        return ViewDocScreen(
          doc: docs[index],
          coordinator: viewDocCoordinator,
        );
      },
    ));
  }

  @action
  onCreateDocTapped() => Modular.to.push(MaterialPageRoute(
        builder: (context) {
          return CreateDocScreen(
            coordinator: Modular.get<CreateDocCoordinator>(),
          );
        },
      ));

  @override
  @action
  dispose() async {
    super.dispose();
    await contract.cancelDocumentStream();
    await documentsStream.close();
    await documentsStreamSubscription.cancel();
  }

  docTitleReactor() => reaction((p0) => selectedDocTitle, (p0) {
        viewDocCoordinator.setTitle(p0);
      });

  @computed
  String get selectedDocTitle =>
      selectedDocIndex == -1 ? "" : docs[selectedDocIndex].title;

  @computed
  List<DocumentEntity> get docs =>
      isCurrentSelected ? currentDocuments : archivedDocuments;
}
