// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/session_information.dart';
part 'storage_logic_coordinator.g.dart';

class StorageLogicCoordinator = _StorageLogicCoordinatorBase
    with _$StorageLogicCoordinator;

abstract class _StorageLogicCoordinatorBase with Store, BaseMobxLogic {
  final StorageContract contract;

  _StorageLogicCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  ObservableList<SessionEntity> finishedSessions =
      ObservableList<SessionEntity>();

  @observable
  ObservableList<SessionEntity> dormantSessions =
      ObservableList<SessionEntity>();

  StreamSubscription sessionStreamSubscription =
      const Stream.empty().listen((event) {});

  @observable
  ObservableStream<GroupSessions> groupSessions =
      ObservableStream(const Stream.empty());

  @observable
  bool sessionsStreamIsCancelled = false;

  @observable
  bool sessionTitleIsUpdated = false;

  @observable
  bool groupIsCreated = false;

  @observable
  bool groupIsDeleted = false;

  @observable
  String queueUID = '';

  @observable
  bool queueIsDeleted = false;

  @observable
  bool sessionIsDeleted = false;

  @observable
  bool groupMembersAreUpdated = false;

  @observable
  ObservableList<GroupInformationEntity> groups = ObservableList.of([]);

  @action
  setQueueUID(String value) => queueUID = value;

  @action
  getGroups() async {
    setState(StoreState.loading);
    final res = await contract.getGroups(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (artifacts) {
        groups = ObservableList.of(artifacts);
        setState(StoreState.loaded);
      },
    );
  }

  @action
  createNewGroup(CreateNewGroupParams params) async {
    groupIsCreated = false;
    final res = await contract.createNewGroup(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (creationStatus) {
        groupIsCreated = creationStatus;
      },
    );
  }

  @action
  deleteGroup(String params) async {
    groupIsDeleted = false;
    final res = await contract.deleteGroup(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (deletionStatus) {
        groupIsDeleted = deletionStatus;
      },
    );
  }

  @action
  createQueue(String groupUID) async {
    queueUID = '';
    final res = await contract.createQueue(groupUID);
    res.fold(
      (failure) => errorUpdater(failure),
      (newQueueUID) {
        queueUID = newQueueUID;
      },
    );
  }

  @action
  deleteSession(String params) async {
    sessionIsDeleted = false;
    final res = await contract.deleteSession(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (deletionStatus) {
        sessionIsDeleted = deletionStatus;
      },
    );
  }

  @action
  updateGroupMembers(UpdateGroupMemberParams params) async {
    groupMembersAreUpdated = false;
    final res = await contract.updateGroupMembers(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (updateStatus) {
        groupMembersAreUpdated = updateStatus;
      },
    );
  }

  @action
  updateSessionTitle(UpdateSessionTitleParams params) async {
    sessionTitleIsUpdated = false;
    final res = await contract.updateSessionTitle(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (updateStatus) {
        sessionTitleIsUpdated = updateStatus;
      },
    );
  }

  @action
  listenToSessions(String groupUID) async {
    final result = await contract.listenToSessions(groupUID);

    result.fold(
      (failure) {
        setErrorMessage(mapFailureToMessage(failure));
      },
      (stream) {
        groupSessions = ObservableStream(stream);
        sessionStreamSubscription = groupSessions.listen((value) {
          print('finished sessions: ${value.finishedSessions}');
          print('dormant sessions: ${value.dormantSessions}');
          finishedSessions = ObservableList.of(value.finishedSessions);
          dormantSessions = ObservableList.of(value.dormantSessions);
        });
      },
    );
  }

  @action
  dispose() async {
    await contract.cancelSessionsStream();
    sessionStreamSubscription = const Stream.empty().listen((event) {});
    groupSessions = ObservableStream(const Stream.empty());
  }

  @computed
  int get currentlySelectedDormantSessionIndex =>
      dormantSessions.indexWhere((element) => element.uid == queueUID);

  @computed
  int get currentlySelectedFinishedSessionIndex =>
      finishedSessions.indexWhere((element) => element.uid == queueUID);

  @computed
  SessionEntity get currentlySelectedDormantSession {
    return currentlySelectedDormantSessionIndex != -1
        ? dormantSessions[currentlySelectedDormantSessionIndex]
        : SessionEntity.empty();
  }

  @computed
  SessionEntity get currentlySelectedFinishedSession {
    return currentlySelectedFinishedSessionIndex != -1
        ? finishedSessions[currentlySelectedFinishedSessionIndex]
        : SessionEntity.empty();
  }
}
