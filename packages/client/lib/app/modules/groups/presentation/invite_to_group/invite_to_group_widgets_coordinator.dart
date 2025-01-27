// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'invite_to_group_widgets_coordinator.g.dart';

class InviteToGroupWidgetsCoordinator = _InviteToGroupWidgetsCoordinatorBase
    with _$InviteToGroupWidgetsCoordinator;

abstract class _InviteToGroupWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator {
  final AnimatedScaffoldStore animatedScaffold;
  final InvitationBodyStore invitationBody;

  _InviteToGroupWidgetsCoordinatorBase({
    required this.animatedScaffold,
    required this.invitationBody,
  }) {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
  }
}
