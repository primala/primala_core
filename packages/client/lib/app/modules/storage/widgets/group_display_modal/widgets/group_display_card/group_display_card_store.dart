// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'group_display_card_store.g.dart';

class GroupDisplayCardStore = _GroupDisplayCardStoreBase
    with _$GroupDisplayCardStore;

abstract class _GroupDisplayCardStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList<SessionEntity> sessions = ObservableList();

  @observable
  String currentlySelectedMessage = '';

  @observable
  int sessionIdToOpen = -1;

  @observable
  int sessionIdToDelete = -1;

  @action
  setSessionIdToOpen(int value) => sessionIdToOpen = value;

  @action
  setSessionIdToDelete(int value) => sessionIdToDelete = value;

  @action
  setSessions(List<SessionEntity> sessions) {
    this.sessions = ObservableList.of(sessions);
  }
}
