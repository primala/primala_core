// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/group_roles.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'edit_group_coordinator.g.dart';

class EditGroupCoordinator = _EditGroupCoordinatorBase
    with _$EditGroupCoordinator;

abstract class _EditGroupCoordinatorBase
    with Store, BaseCoordinator, BaseMobxLogic, BaseWidgetsCoordinator {
  final GroupNameTextFieldStore groupNameTextField;
  final GroupsContract groupsContract;
  final GroupRolesContract groupRolesContract;
  @override
  final CaptureScreen captureScreen;

  _EditGroupCoordinatorBase({
    required this.groupNameTextField,
    required this.groupsContract,
    required this.captureScreen,
    required this.groupRolesContract,
  }) {
    initBaseLogicActions();
    initBaseCoordinatorActions();
    initBaseWidgetsCoordinatorActions();
  }

  @observable
  GroupEntity group = GroupEntity.initial();

  @observable
  bool isNotTheOnlyAdmin = false;

  @observable
  bool isAdmin = false;

  @observable
  String userUid = '';

  @observable
  Function onGroupLeft = () {};

  @action
  constructor(GroupEntity group, Function onGroupLeft) async {
    this.group = group;
    this.onGroupLeft = onGroupLeft;
    groupNameTextField.controller.text = group.name;
    groupNameTextField.setIsEnabled(false);

    await getGroupMembers();
    await captureScreen(GroupsConstants.editGroup);
  }

  @action
  getGroupMembers() async {
    final res = await groupRolesContract.getGroupMembers(group.id);
    res.fold(
      (failure) => errorUpdater(failure),
      (groupMembers) {
        isNotTheOnlyAdmin = groupMembers
            .where((element) =>
                (element.role == GroupRole.admin && !element.isUser))
            .isNotEmpty;

        isAdmin = groupMembers
            .where((element) =>
                (element.role == GroupRole.admin && element.isUser))
            .isNotEmpty;
        userUid = groupMembers.firstWhere((element) => element.isUser).userUid;
        setShowWidgets(true);
      },
    );
  }

  @action
  leaveGroup() async {
    await groupRolesContract.removeUserRole(
      UserRoleParams(
        userUid: userUid,
        groupId: group.id,
        role: GroupRole.none,
      ),
    );
    await onGroupLeft();
    onGoBack();
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
    await groupsContract.deleteGroup(group.id);
    Modular.to.pop();
  }
}
