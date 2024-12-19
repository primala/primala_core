// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_relationships.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
part 'home_logic_coordinator.g.dart';

class HomeLogicCoordinator = _HomeLogicCoordinatorBase
    with _$HomeLogicCoordinator;

abstract class _HomeLogicCoordinatorBase with Store, BaseMobxLogic {
  final HomeContract contract;

  _HomeLogicCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  ObservableList<CollaboratorRequests> collaboratorRequests =
      ObservableList.of([]);

  @observable
  ObservableList<CollaboratorRelationshipEntity> collaboratorRelationships =
      ObservableList.of([]);

  @observable
  bool requestStatusUpdated = false;

  @observable
  bool requestSent = false;

  StreamSubscription? _collaboratorRequestSubscription;
  StreamSubscription? _collaboratorRelationshipSubscription;

  @action
  listenToCollaboratorRequests() async {
    setState(StoreState.loading);
    final res = await contract.listenToCollaboratorRequests(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (stream) {
        _collaboratorRequestSubscription = stream.listen((requests) {
          collaboratorRequests = ObservableList.of(requests);
          setState(StoreState.loaded);
        });
      },
    );
  }

  @action
  cancelCollaboratorRequestsStream() async {
    await contract.cancelCollaboratorRequestsStream(const NoParams());
  }

  @action
  listenToCollaboratorRelationships() async {
    setState(StoreState.loading);
    final res =
        await contract.listenToCollaboratorRelationships(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (stream) {
        _collaboratorRelationshipSubscription = stream.listen((relationships) {
          collaboratorRelationships = ObservableList.of(relationships);
          setState(StoreState.loaded);
        });
      },
    );
  }

  @action
  cancelCollaboratorRelationshipsStream() async {
    await contract.cancelCollaboratorRelationshipsStream(const NoParams());
  }

  @action
  updateRequestStatus(UpdateRequestStatusParams params) async {
    requestStatusUpdated = false;
    final res = await contract.updateRequestStatus(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) {
        requestStatusUpdated = status;
      },
    );
  }

  @action
  sendRequest(SendRequestParams params) async {
    requestSent = false;
    final res = await contract.sendRequest(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) {
        requestSent = status;
      },
    );
  }

  @action
  void resetValues() {
    collaboratorRequests = ObservableList.of([]);
    collaboratorRelationships = ObservableList.of([]);
  }

  @action
  void dispose() {
    _collaboratorRequestSubscription?.cancel();
    _collaboratorRelationshipSubscription?.cancel();
    resetValues();
  }
}
