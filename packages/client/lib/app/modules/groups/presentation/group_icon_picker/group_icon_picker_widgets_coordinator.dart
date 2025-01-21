// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'group_icon_picker_widgets_coordinator.g.dart';

class GroupIconPickerWidgetsCoordinator = _GroupIconPickerWidgetsCoordinatorBase
    with _$GroupIconPickerWidgetsCoordinator;

abstract class _GroupIconPickerWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _GroupIconPickerWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
