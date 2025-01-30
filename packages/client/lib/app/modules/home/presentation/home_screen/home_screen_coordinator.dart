// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'home_screen_coordinator.g.dart';

class HomeScreenCoordinator = _HomeScreenCoordinatorBase
    with _$HomeScreenCoordinator;

abstract class _HomeScreenCoordinatorBase
    with Store, BaseWidgetsCoordinator, BaseMobxLogic {
  final HomeContract contract;

  _HomeScreenCoordinatorBase({required this.contract}) {
    initBaseLogicActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  GroupEntity selectedGroup = GroupEntity.initial();

  @action
  constructor() async {
    final activeGroupId = Modular.args.data[HomeConstants.groupId] ?? -1;
    if (activeGroupId == -1) {
      Modular.to.navigate(GroupsConstants.groupPicker);
    } else {
      await getGroup(activeGroupId);
    }
  }

  @action
  clearActiveGroup() async {
    final res = await contract.clearActiveGroup();
    res.fold((failure) => errorUpdater(failure), (success) {
      setShowWidgets(false);
      Timer(Seconds.get(0, milli: 500), () {
        Modular.to.navigate(GroupsConstants.groupPicker);
      });
    });
  }

  @action
  getGroup(int groupId) async {
    final res = await contract.getGroup(groupId);
    res.fold((failure) => errorUpdater(failure), (group) {
      selectedGroup = group;
      fadeInWidgets();
    });
  }
}
