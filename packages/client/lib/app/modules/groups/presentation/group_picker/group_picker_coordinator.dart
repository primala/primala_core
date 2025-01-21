// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_picker_coordinator.g.dart';

class GroupPickerCoordinator = _GroupPickerCoordinatorBase
    with _$GroupPickerCoordinator;

abstract class _GroupPickerCoordinatorBase with Store {
  final GroupPickerWidgetsCoordinator widgets;

  _GroupPickerCoordinatorBase({
    required this.widgets,
  });

  @action
  constructor() {
    widgets.constructor();
  }
}
