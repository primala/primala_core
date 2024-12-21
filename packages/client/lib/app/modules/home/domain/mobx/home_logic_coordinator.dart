// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/collaborator_requests.dart';
import 'package:nokhte_backend/tables/realtime_active_sessions.dart';
import 'package:nokhte_backend/types/types.dart';
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
  ObservableList<UserInformationEntity> collaborators = ObservableList.of([]);

  @observable
  bool sessionJoined = false;

  @observable
  ObservableList<SessionRequests> sessionRequests = ObservableList.of([]);

  @observable
  bool requestStatusUpdated = false;

  @observable
  bool sessionIsInitialized = false;

  @observable
  bool requestSent = false;

  StreamSubscription? _collaboratorRequestSubscription;
  StreamSubscription? _collaboratorRelationshipSubscription;
  StreamSubscription? _sessionRequestsSubscription;

  @observable
  String userUID = '';

  @observable
  UserInformationEntity userInformation = UserInformationEntity.initial();

  @observable
  StoreState requestListeningStatus = StoreState.initial;

  @action
  setRequestListeningStatus(StoreState status) =>
      requestListeningStatus = status;

  @observable
  StoreState relationshipsListeningStatus = StoreState.initial;

  @action
  setRelationshipsListeningStatus(StoreState status) =>
      relationshipsListeningStatus = status;

  @observable
  StoreState sessionRequestsListeningStatus = StoreState.initial;

  @action
  setSessionRequestsListeningStatus(StoreState status) =>
      sessionRequestsListeningStatus = status;

  @action
  listenToCollaboratorRequests() async {
    setRequestListeningStatus(StoreState.loading);
    final res = await contract.listenToCollaboratorRequests(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (stream) {
        _collaboratorRequestSubscription = stream.listen((requests) {
          collaboratorRequests = ObservableList.of(requests);
          setRequestListeningStatus(StoreState.loaded);
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
    setRelationshipsListeningStatus(StoreState.loading);
    final res =
        await contract.listenToCollaboratorRelationships(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (stream) {
        _collaboratorRelationshipSubscription = stream.listen((relationships) {
          collaborators = ObservableList.of(relationships);
          setRelationshipsListeningStatus(StoreState.loaded);
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
  getUserInformation() async {
    final res = await contract.getUserInformation(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (info) {
        userInformation = info;
      },
    );
  }

  @action
  initializeSession(InitializeSessionParams params) async {
    final res = await contract.initializeSession(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) {
        sessionIsInitialized = status;
      },
    );
  }

  @action
  joinSession(JoinSessionParams params) async {
    sessionJoined = false;
    final res = await contract.joinSession(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (status) {
        sessionJoined = status;
      },
    );
  }

  @action
  listenToSessionRequests() async {
    setSessionRequestsListeningStatus(StoreState.loading);
    final res = await contract.listenToSessionRequests(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (stream) {
        _sessionRequestsSubscription = stream.listen((requests) {
          sessionRequests = ObservableList.of(requests);
          setSessionRequestsListeningStatus(StoreState.loaded);
        });
      },
    );
  }

  @action
  void dispose() {
    _collaboratorRequestSubscription?.cancel();
    _collaboratorRelationshipSubscription?.cancel();
    _sessionRequestsSubscription?.cancel();
    resetValues();
  }

  @action
  void resetValues() {
    collaboratorRequests = ObservableList.of([]);
    collaborators = ObservableList.of([]);
    sessionRequests = ObservableList.of([]);
  }
}
