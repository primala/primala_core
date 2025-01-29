// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_picker_coordinator.g.dart';

class GroupPickerCoordinator = _GroupPickerCoordinatorBase
    with _$GroupPickerCoordinator;

abstract class _GroupPickerCoordinatorBase
    with Store, BaseMobxLogic, Reactions {
  final GroupPickerWidgetsCoordinator widgets;
  final GroupsContractImpl groupsContract;
  final UserContractImpl userContract;

  _GroupPickerCoordinatorBase({
    required this.widgets,
    required this.groupsContract,
    required this.userContract,
  }) {
    initBaseLogicActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await getGroups();
  }

  initReactors() {
    disposers.add(groupsReactor());
    disposers.add(widgets.createGroupReactor());
    disposers.add(widgets.editGroupReactor());
    disposers.add(widgets.activeGroupReactor(updateActiveGroup));
  }

  @observable
  ObservableList<GroupEntity> groups = ObservableList<GroupEntity>();

  @action
  getGroups() async {
    final res = await groupsContract.getGroups();
    res.fold(
      (failure) => errorUpdater(failure),
      (incomingGroups) => groups = ObservableList.of(incomingGroups),
    );
  }

  @action
  onSettingsTapped() {
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.accountSettings);
    });
  }

  @action
  onInboxTapped() {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return InboxScreen(
          coordinator: Modular.get<InboxCoordinator>(),
        );
      }),
    );
  }

  @action
  updateActiveGroup(int groupId) async {
    await userContract.updateActiveGroup(groupId);
  }

  groupsReactor() => reaction((p0) => groups, (p0) {
        widgets.groupDisplay.setGroups(p0);
        widgets.groupDisplay.setWidgetVisibility(true);
      });
}
