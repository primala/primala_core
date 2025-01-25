// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'create_group_widgets_coordinator.g.dart';

class CreateGroupWidgetsCoordinator = _CreateGroupWidgetsCoordinatorBase
    with _$CreateGroupWidgetsCoordinator;

abstract class _CreateGroupWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final AnimatedScaffoldStore animatedScaffold;
  final GroupNameTextFieldStore groupNameTextField;

  _CreateGroupWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.groupNameTextField,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
  }
}
