// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'create_group_coordinator.g.dart';

class CreateGroupCoordinator = _CreateGroupCoordinatorBase
    with _$CreateGroupCoordinator;

abstract class _CreateGroupCoordinatorBase with Store {
  final CreateGroupWidgetsCoordinator widgets;

  _CreateGroupCoordinatorBase({
    required this.widgets,
  });
}
