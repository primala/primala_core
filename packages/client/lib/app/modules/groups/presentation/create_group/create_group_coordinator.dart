// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'create_group_coordinator.g.dart';

class CreateGroupCoordinator = _CreateGroupCoordinatorBase
    with _$CreateGroupCoordinator;

abstract class _CreateGroupCoordinatorBase
    with Store, Reactions, BaseMobxLogic {
  final CreateGroupWidgetsCoordinator widgets;
  final GroupsContractImpl contract;

  _CreateGroupCoordinatorBase({
    required this.widgets,
    required this.contract,
  });

  @action
  constructor() {
    widgets.constructor();
  }

  @action
  onGoBack() {
    if (!widgets.showWidgets) return;
    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(GroupsConstants.groupPicker);
    });
  }

  @action
  onPencilIconTap() {
    if (widgets.showWidgets) return;
    widgets.setShowWidgets(false);
    final profileGradient = widgets.groupNameTextField.profileGradient;

    Timer(Seconds.get(0, milli: 500), () {
      Modular.to.navigate(
        GroupsConstants.groupIconPicker,
        arguments: {
          GroupsConstants.PROFILE_GRADIENT: profileGradient,
        },
      );
    });
  }

  @action
  createGroup() async {
    final params = CreateGroupParams(
      groupName: widgets.groupNameTextField.groupName,
      profileGradient: widgets.groupNameTextField.profileGradient,
    );
    final res = await contract.createGroup(params);
    res.fold((error) {
      errorUpdater(error);
    }, (groupId) {
      widgets.setShowWidgets(false);
      Modular.to.navigate(
        GroupsConstants.editGroup,
        arguments: {
          GroupsConstants.GROUP_ID: groupId,
        },
      );
    });
  }
}
