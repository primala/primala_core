// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'group_display_queue_card_store.g.dart';

class GroupDisplayQueueCardStore = _GroupDisplayQueueCardStoreBase
    with _$GroupDisplayQueueCardStore;

abstract class _GroupDisplayQueueCardStoreBase extends BaseWidgetStore
    with Store {
  @observable
  ObservableList<bool> expandedStates = ObservableList<bool>();

  @observable
  ObservableList queues = ObservableList();

  @observable
  String currentlySelectedMessage = '';

  @observable
  int currentlySelectedIndex = -1;

  @action
  setCurrentlySelectedIndex(int index) => currentlySelectedIndex = index;

  @action
  setQueues(List queues) {
    this.queues = ObservableList.of(queues);
    expandedStates = ObservableList.of(List.filled(queues.length, false));
  }

  @action
  toggleExpansion(int index) {
    if (index >= 0 && index < expandedStates.length) {
      expandedStates[index] = !expandedStates[index];
    }
  }

  @action
  setCurrentlySelectedMessage(String message) {
    currentlySelectedMessage = message;
  }

  @computed
  String get queueUIDToDelete => currentlySelectedIndex == -1 || queues.isEmpty
      ? ''
      : queues[currentlySelectedIndex].uid;
}
