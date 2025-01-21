// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'account_icon_picker_widgets_coordinator.g.dart';

class AccountIconPickerWidgetsCoordinator = _AccountIconPickerWidgetsCoordinatorBase
    with _$AccountIconPickerWidgetsCoordinator;

abstract class _AccountIconPickerWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _AccountIconPickerWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
