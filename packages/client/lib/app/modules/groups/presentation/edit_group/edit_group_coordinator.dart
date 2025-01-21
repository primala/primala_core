// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'edit_group_coordinator.g.dart';

class EditGroupCoordinator = _EditGroupCoordinatorBase
    with _$EditGroupCoordinator;

abstract class _EditGroupCoordinatorBase with Store {
  final EditGroupWidgetsCoordinator widgets;

  _EditGroupCoordinatorBase({
    required this.widgets,
  });
}
