// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_members_coordinator.g.dart';

class GroupMembersCoordinator = _GroupMembersCoordinatorBase
    with _$GroupMembersCoordinator;

abstract class _GroupMembersCoordinatorBase with Store {
  final GroupMembersWidgetsCoordinator widgets;

  _GroupMembersCoordinatorBase({
    required this.widgets,
  });
}
