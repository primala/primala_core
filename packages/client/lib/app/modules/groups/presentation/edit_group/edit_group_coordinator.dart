// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
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
  constructor(GroupEntity group) async {
    this.group = group;
    widgets.constructor(group);
  }

  @action
  onGoBack() => Modular.to.pop();

  @action
  goToInvite() {
    Modular.to.push(
      MaterialPageRoute(
        builder: (BuildContext context) => InviteToGroupScreen(
          group: group,
          coordinator: Modular.get<InviteToGroupCoordinator>(),
        ),
      ),
    );
  }

  @action
  goToGroupMembers() {
    Modular.to.push(
      MaterialPageRoute(
        builder: (BuildContext context) => GroupMembersScreen(
          group: group,
          coordinator: Modular.get<GroupMembersCoordinator>(),
        ),
      ),
    );
  }

  @action
  deleteGroup() async {
    await contract.deleteGroup(group.id);
    Modular.to.pop();
  }
}
