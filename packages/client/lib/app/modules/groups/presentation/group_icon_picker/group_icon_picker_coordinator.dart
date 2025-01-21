// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_icon_picker_coordinator.g.dart';

class GroupIconPickerCoordinator = _GroupIconPickerCoordinatorBase
    with _$GroupIconPickerCoordinator;

abstract class _GroupIconPickerCoordinatorBase with Store {
  final GroupIconPickerWidgetsCoordinator widgets;

  _GroupIconPickerCoordinatorBase({
    required this.widgets,
  });
}
