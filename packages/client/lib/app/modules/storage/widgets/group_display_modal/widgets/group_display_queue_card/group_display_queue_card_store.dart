// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_queue_card_store.g.dart';

class GroupDisplayQueueCardStore = _GroupDisplayQueueCardStoreBase
    with _$GroupDisplayQueueCardStore;

abstract class _GroupDisplayQueueCardStoreBase extends BaseWidgetStore
    with Store {
  @observable
  ObservableList<bool> expandedStates = ObservableList<bool>();

  @observable
  ObservableList<QueueEntity> queues = ObservableList<QueueEntity>();

  @observable
  String currentlySelectedMessage = '';

  @action
  setQueues(List<QueueEntity> queues) {
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
}
