// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte_backend/tables/session_information.dart';
part 'group_display_session_card_store.g.dart';

class GroupDisplaySessionCardStore = _GroupDisplaySessionCardStoreBase
    with _$GroupDisplaySessionCardStore;

abstract class _GroupDisplaySessionCardStoreBase extends BaseWidgetStore
    with Store {
  @observable
  ObservableList<bool> expandedStates = ObservableList<bool>();

  @observable
  ObservableList<SessionEntity> sessions = ObservableList<SessionEntity>();

  @observable
  String currentlySelectedMessage = '';

  @observable
  int currentlySelectedIndex = -1;

  @action
  setCurrentlySelectedIndex(int index) {
    currentlySelectedIndex = index;
  }

  @action
  setSessions(List<SessionEntity> sessions) {
    this.sessions = ObservableList.of(sessions);
    expandedStates = ObservableList.of(List.filled(sessions.length, false));
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
  String get sessionUIDToDelete =>
      currentlySelectedIndex == -1 || sessions.isEmpty
          ? ''
          : sessions[currentlySelectedIndex].uid;

  @computed
  String get currentlySelectedUID =>
      currentlySelectedIndex == -1 || sessions.isEmpty
          ? ''
          : sessions[currentlySelectedIndex].uid;
}
