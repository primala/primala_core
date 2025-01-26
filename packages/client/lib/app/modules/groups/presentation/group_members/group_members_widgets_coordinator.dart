// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'group_members_widgets_coordinator.g.dart';

class GroupMembersWidgetsCoordinator = _GroupMembersWidgetsCoordinatorBase
    with _$GroupMembersWidgetsCoordinator;

abstract class _GroupMembersWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final AnimatedScaffoldStore animatedScaffold;

  _GroupMembersWidgetsCoordinatorBase({
    required this.animatedScaffold,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
  }
}
