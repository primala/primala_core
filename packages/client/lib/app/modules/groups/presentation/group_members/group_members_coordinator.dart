// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_members_coordinator.g.dart';

class GroupMembersCoordinator = _GroupMembersCoordinatorBase
    with _$GroupMembersCoordinator;

abstract class _GroupMembersCoordinatorBase with Store {
  final GroupMembersWidgetsCoordinator widgets;
  final GroupRolesContract contract;

  _GroupMembersCoordinatorBase({
    required this.widgets,
    required this.contract,
  });

  @observable
  GroupEntity group = GroupEntity.initial();

  @action
  constructor(GroupEntity group) async {
    this.group = group;
    widgets.constructor();
  }

  @action
  onGoBack() {
    if (!widgets.showWidgets) return;
    widgets.setShowWidgets(false);
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(
        GroupsConstants.editGroup,
        arguments: {
          GroupsConstants.GROUP_ENTITY: group,
        },
      );
    });
  }
}
