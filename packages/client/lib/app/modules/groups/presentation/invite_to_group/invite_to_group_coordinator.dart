// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'invite_to_group_coordinator.g.dart';

class InviteToGroupCoordinator = _InviteToGroupCoordinatorBase
    with _$InviteToGroupCoordinator;

abstract class _InviteToGroupCoordinatorBase with Store {
  final InviteToGroupWidgetsCoordinator widgets;
  final GroupsContractImpl contract;

  _InviteToGroupCoordinatorBase({
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
    Modular.to.pop();
  }
}
