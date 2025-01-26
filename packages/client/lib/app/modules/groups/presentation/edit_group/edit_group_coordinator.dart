// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'edit_group_coordinator.g.dart';

class EditGroupCoordinator = _EditGroupCoordinatorBase
    with _$EditGroupCoordinator;

abstract class _EditGroupCoordinatorBase with Store {
  final EditGroupWidgetsCoordinator widgets;
  final GroupsContractImpl contract;

  _EditGroupCoordinatorBase({
    required this.widgets,
    required this.contract,
  });

  @observable
  GroupEntity group = GroupEntity.initial();

  @action
  constructor() async {
    group = Modular.args.data[GroupsConstants.GROUP_ENTITY];
    widgets.constructor(group);
  }

  @action
  onGoBack() {
    if (!widgets.showWidgets) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.groupPicker);
    });
  }

  @action
  goToInvite() {
    if (!widgets.showWidgets) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(
        GroupsConstants.inviteToGroup,
        arguments: {
          GroupsConstants.GROUP_ENTITY: group,
        },
      );
    });
  }

  @action
  goToGroupMembers() {
    if (!widgets.showWidgets) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(
        GroupsConstants.groupMembers,
        arguments: {
          GroupsConstants.GROUP_ENTITY: group,
        },
      );
    });
  }

  @action
  deleteGroup() async {
    if (!widgets.showWidgets) return;
    await contract.deleteGroup(group.id);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.groupPicker);
    });
  }
}
