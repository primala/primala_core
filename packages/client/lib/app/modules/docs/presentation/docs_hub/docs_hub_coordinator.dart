// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';
part 'docs_hub_coordinator.g.dart';

class DocsHubCoordinator = _DocsHubCoordinatorBase with _$DocsHubCoordinator;

abstract class _DocsHubCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic, Reactions {
  final DocsContract contract;
  final ActiveGroup activeGroup;
  final ViewDocCoordinator viewDocCoordinator;

  _DocsHubCoordinatorBase({
    required this.contract,
    required this.activeGroup,
    required this.viewDocCoordinator,
  }) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  ObservableList<DocumentEntity> documents = ObservableList();

  @observable
  int selectedDocIndex = -1;

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
  }

  @action
  listenToDocuments() async {
    final res = await contract.listenToDocuments(activeGroup.groupId);
    res.fold((failure) => errorUpdater(failure), (stream) {
      documentsStream = ObservableStream(stream);
      documentsStreamSubscription = documentsStream.listen((event) {
        print('any documents $event');
        documents = ObservableList.of(event);
      });
    });
  }

  @action
  onDocTapped(int index) async {
    selectedDocIndex = index;
    Modular.to.push(MaterialPageRoute(
      builder: (context) {
        return ViewDocScreen(
          doc: documents[index],
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
    documents = ObservableList();
    documentsStreamSubscription = const Stream.empty().listen((event) {});

    await contract.cancelDocumentStream();
  }

  docTitleReactor() => reaction((p0) => selectedDocTitle, (p0) {
        viewDocCoordinator.setTitle(p0);
      });

  @computed
  String get selectedDocTitle =>
      selectedDocIndex == -1 ? "" : documents[selectedDocIndex].title;
}
