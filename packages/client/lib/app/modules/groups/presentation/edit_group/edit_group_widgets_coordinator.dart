// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'edit_group_widgets_coordinator.g.dart';

class EditGroupWidgetsCoordinator = _EditGroupWidgetsCoordinatorBase
    with _$EditGroupWidgetsCoordinator;

abstract class _EditGroupWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final AnimatedScaffoldStore animatedScaffold;
  final GroupNameTextFieldStore groupNameTextField;

  _EditGroupWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.groupNameTextField,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor(GroupEntity group) {
    groupNameTextField.controller.text = group.name;
    groupNameTextField.setIsEnabled(false);
    fadeInWidgets();
  }
}
