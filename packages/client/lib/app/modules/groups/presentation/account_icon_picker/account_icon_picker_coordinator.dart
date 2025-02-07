// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'account_icon_picker_coordinator.g.dart';

class AccountIconPickerCoordinator = _AccountIconPickerCoordinatorBase
    with _$AccountIconPickerCoordinator;

abstract class _AccountIconPickerCoordinatorBase with Store {
  final AccountIconPickerWidgetsCoordinator widgets;

  _AccountIconPickerCoordinatorBase({
    required this.widgets,
  });
}
