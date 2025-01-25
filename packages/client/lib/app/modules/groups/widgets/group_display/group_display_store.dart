// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/types/types.dart';
part 'group_display_store.g.dart';

class GroupDisplayStore = _GroupDisplayStoreBase with _$GroupDisplayStore;

abstract class _GroupDisplayStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList<GroupEntity> groups = ObservableList.of([
    const GroupEntity(
      groupId: 1,
      groupName:
          'Group Name Something Super Super Long This Is Really Really Long',
      isAdmin: true,
      profileGradient: ProfileGradient.twilightSky,
    ),
  ]);

  @observable
  int activeGroupId = 0;

  @observable
  int groupIdToEdit = 0;

  @observable
  int createGroupTapCount = 0;

  @observable
  bool isManagingGroups = false;

  @observable
  bool showPencilIcon = false;

  @observable
  bool showMonogram = true;

  @action
  toggleIsManagingGroups(bool value) {
    isManagingGroups = value;

    if (isManagingGroups) {
      showMonogram = false;
      Timer(Seconds.get(0, milli: 500), () {
        showPencilIcon = true;
      });
    } else {
      showPencilIcon = false;
      Timer(Seconds.get(0, milli: 500), () {
        showMonogram = true;
      });
    }
  }

  @action
  onCreateGroupTapped() => createGroupTapCount++;

  @action
  onGroupTap(int index) {
    if (isManagingGroups) {
      if (!groups[index].isAdmin) return;
      groupIdToEdit = index;
    } else {
      activeGroupId = index;
    }
  }

  @action
  setGroups(ObservableList<GroupEntity> groups) => this.groups = groups;
}
