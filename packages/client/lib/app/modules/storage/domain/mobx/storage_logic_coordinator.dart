// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
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
  //

  @observable
  bool groupIsCreated = false;

  @observable
  bool groupIsDeleted = false;

  @observable
  bool queueIsCreated = false;

  @observable
  bool groupMembersAreUpdated = false;

  @observable
  ObservableList<GroupInformationEntity> groups = ObservableList.of([]);

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
  createQueue(CreateQueueParams params) async {
    queueIsCreated = false;
    final res = await contract.createQueue(params);
    res.fold(
      (failure) => errorUpdater(failure),
      (creationStatus) {
        queueIsCreated = creationStatus;
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
}
