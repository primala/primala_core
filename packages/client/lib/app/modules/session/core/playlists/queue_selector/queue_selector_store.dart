// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'queue_selector_store.g.dart';

class QueueSelectorStore = _QueueSelectorStoreBase with _$QueueSelectorStore;

abstract class _QueueSelectorStoreBase extends BaseWidgetStore with Store {
  @observable
  GroupInformationEntity selectedGroup = GroupInformationEntity.empty();

  @observable
  QueueEntity selectedQueue = QueueEntity.empty();

  @observable
  ObservableList<GroupInformationEntity> groups =
      ObservableList<GroupInformationEntity>();

  @observable
  ObservableList<GroupInformationEntity> expandedGroups =
      ObservableList<GroupInformationEntity>();

  @action
  void setGroups(List<GroupInformationEntity> newGroups) {
    initFadeIn();
    groups = ObservableList.of(newGroups);
  }

  @action
  void toggleGroupExpansion(GroupInformationEntity group) {
    if (expandedGroups.contains(group)) {
      expandedGroups.remove(group);
    } else {
      expandedGroups.add(group);
    }
  }

  @action
  void selectGroup(GroupInformationEntity group) {
    if (group == selectedGroup) {
      selectedGroup = GroupInformationEntity.empty();
    } else {
      selectedGroup = group;
    }
  }

  @action
  void selectQueue(QueueEntity queue) {
    if (queue == selectedQueue) {
      selectedQueue = QueueEntity.empty();
    } else {
      selectedQueue = queue;
    }
    // selectedGroup = queue
    // note the second one doesn't select for some reason
    // this is really odd behavior
    ;
  }
}
