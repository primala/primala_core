// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/tables/sessions.dart';
import 'package:nokhte_backend/types/types.dart';
part 'session_starter_coordinator.g.dart';

class SessionStarterCoordinator = _SessionStarterCoordinatorBase
    with _$SessionStarterCoordinator;

abstract class _SessionStarterCoordinatorBase
    with Store, BaseMobxLogic, BaseWidgetsCoordinator {
  final PreSessionContract contract;
  final ActiveGroup activeGroup;

  _SessionStarterCoordinatorBase({
    required this.contract,
    required this.activeGroup,
  }) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  ObservableList<UserEntity> allCollaborators = ObservableList.of([]);

  @observable
  ObservableList<DocumentEntity> allDocuments = ObservableList.of([]);

  @action
  constructor() async {
    setShowWidgets(true);
    await getGroupMembers();
    await getDocuments();
  }

  @action
  initializeSession(
      List<UserEntity> collaborators, List<DocumentEntity> docs) async {
    final docIds = docs.map((e) => e.id).toList();
    final params = InitializeSessionParams(
      collaborators: collaborators,
      groupId: activeGroup.groupId,
      docIds: docIds,
    );
    final res = await contract.initializeSession(params);
    res.fold((failure) => errorUpdater(failure), (success) {
      setShowWidgets(false);
      Timer(Seconds.get(0, milli: 500), () {
        Modular.to.navigate(SessionConstants.lobby);
      });
    });
  }

  @action
  getDocuments() async {
    final res = await contract.getDocuments(activeGroup.groupId);
    res.fold(
      (failure) => errorUpdater(failure),
      (success) {
        allDocuments = ObservableList.of(success);
      },
    );
  }

  @action
  getGroupMembers() async {
    final res = await contract.getGroupMembers(activeGroup.groupId);
    res.fold(
      (failure) => errorUpdater(failure),
      (success) {
        allCollaborators = ObservableList.of(success);
      },
    );
  }
}
