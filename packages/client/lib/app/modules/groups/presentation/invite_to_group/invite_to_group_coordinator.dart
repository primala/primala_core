// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'invite_to_group_coordinator.g.dart';

class InviteToGroupCoordinator = _InviteToGroupCoordinatorBase
    with _$InviteToGroupCoordinator;

abstract class _InviteToGroupCoordinatorBase with Store {
  final InviteToGroupWidgetsCoordinator widgets;

  _InviteToGroupCoordinatorBase({
    required this.widgets,
  });
}
