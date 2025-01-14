// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'session_starter_dropdown_store.g.dart';

class SessionStarterDropdownStore = _SessionStarterDropdownStore
    with _$SessionStarterDropdownStore;

abstract class _SessionStarterDropdownStore extends BaseWidgetStore with Store {
  @observable
  GroupInformationEntity? selectedGroup;

  @observable
  SessionEntity? selectedQueue;

  @observable
  ObservableList<GroupInformationEntity> groups =
      ObservableList<GroupInformationEntity>();

  @observable
  ObservableList<SessionEntity> availableQueues =
      ObservableList<SessionEntity>();

  @action
  setAvailableQueues(List<SessionEntity> queues) {
    availableQueues = ObservableList.of(queues);
  }

  @action
  void setSelectedGroup(GroupInformationEntity? group) {
    selectedGroup = group;
    selectedQueue = null; // Reset queue selection when group changes
  }

  @action
  void setSelectedQueue(SessionEntity? queue) {
    selectedQueue = queue;
  }

  @action
  onTap() {
    tapCount++;
  }

  @action
  void setGroups(ObservableList<GroupInformationEntity> newGroups) {
    groups = newGroups;
  }

  @computed
  String get groupUID => '';

  @computed
  String get queueUID => '';
}
