// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'account_settings_widgets_coordinator.g.dart';

class AccountSettingsWidgetsCoordinator = _AccountSettingsWidgetsCoordinatorBase
    with _$AccountSettingsWidgetsCoordinator;

abstract class _AccountSettingsWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _AccountSettingsWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
