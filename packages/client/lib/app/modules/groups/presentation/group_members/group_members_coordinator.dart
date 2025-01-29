// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
part 'group_members_coordinator.g.dart';

class GroupMembersCoordinator = _GroupMembersCoordinatorBase
    with _$GroupMembersCoordinator;

abstract class _GroupMembersCoordinatorBase with Store, BaseMobxLogic {
  final GroupMembersWidgetsCoordinator widgets;
  final GroupRolesContract contract;

  _GroupMembersCoordinatorBase({
    required this.widgets,
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  GroupEntity group = GroupEntity.initial();

  @observable
  ObservableList<GroupRoleEntity> groupMembers =
      ObservableList<GroupRoleEntity>();

  @action
  constructor(GroupEntity group) async {
    this.group = group;
    await getGroupMembers();
  }

  @action
  getGroupMembers() async {
    final res = await contract.getGroupMembers(group.id);
    res.fold(
      (failure) => errorUpdater(failure),
      (groupMembers) => this.groupMembers = ObservableList.of(groupMembers),
    );
  }

  @action
  onMemberTapped(GroupRoleEntity member) {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return SelectRoleScreen(
          onRoleSelected: (role) async {
            if (role != GroupRole.none) {
              await contract.updateUserRole(
                UserRoleParams(
                  userUid: member.userUid,
                  groupId: group.id,
                  role: role,
                ),
              );
            } else {
              await contract.removeUserRole(
                UserRoleParams(
                  userUid: member.userUid,
                  groupId: group.id,
                  role: member.role,
                ),
              );
            }
            await getGroupMembers();
            Modular.to.pop();
          },
        );
      }),
    );
  }

  @action
  onGoBack() => Modular.to.pop();
}
