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
    with Store, BaseWidgetsCoordinator, BaseMobxLogic {
  final DocsContract contract;
  final ActiveGroup activeGroup;

  _DocsHubCoordinatorBase({
    required this.contract,
    required this.activeGroup,
  }) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  ObservableList<DocumentEntity> documents = ObservableList();

  @observable
  ObservableStream<DocumentEntities> documentsStream =
      ObservableStream(const Stream.empty());

  @observable
  StreamSubscription documentsStreamSubscription =
      const Stream.empty().listen((event) {});

  @action
  constructor() async {
    fadeInWidgets();
    await listenToDocuments();
  }

  @action
  listenToDocuments() async {
    print('active group id ${activeGroup.groupId}');
    final res = await contract.listenToDocuments(activeGroup.groupId);
    res.fold((failure) => errorUpdater(failure), (stream) {
      documentsStream = ObservableStream(stream);
      documentsStreamSubscription = documentsStream.listen((event) {
        print('is there any event here $event');
        documents = ObservableList.of(event);
      });
    });
  }

  @action
  onDocTapped(int docId) async {}

  @action
  onCreateDocTapped() => Modular.to.push(MaterialPageRoute(
        builder: (context) {
          return CreateDocScreen(
            coordinator: Modular.get<CreateDocCoordinator>(),
          );
        },
      ));

  @action
  dispose() async {
    await documentsStreamSubscription.cancel();
    await contract.cancelDocumentStream();
  }
}
