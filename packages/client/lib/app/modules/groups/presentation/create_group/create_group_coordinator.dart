// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
part 'create_group_coordinator.g.dart';

class CreateGroupCoordinator = _CreateGroupCoordinatorBase
    with _$CreateGroupCoordinator;

abstract class _CreateGroupCoordinatorBase
    with Store, BaseMobxLogic, BaseCoordinator {
  final GroupsContractImpl contract;
  final GroupNameTextFieldStore groupNameTextField;
  @override
  final CaptureScreen captureScreen;

  _CreateGroupCoordinatorBase({
    required this.groupNameTextField,
    required this.contract,
    required this.captureScreen,
  }) {
    initBaseLogicActions();
    initBaseCoordinatorActions();
  }

  @action
  constructor() async => await captureScreen(GroupsConstants.createGroup);

  @action
  onGoBack() {
    Modular.to.pop();
  }

  @action
  onPencilIconTap() {}

  @action
  createGroup() async {
    final params = CreateGroupParams(
      groupName: groupNameTextField.groupName,
      profileGradient: groupNameTextField.profileGradient,
    );
    final res = await contract.createGroup(params);
    res.fold((error) {
      errorUpdater(error);
    }, (groupId) {
      Modular.to.pop();
    });
  }
}
