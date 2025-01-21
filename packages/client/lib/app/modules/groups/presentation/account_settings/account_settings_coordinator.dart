// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'account_settings_coordinator.g.dart';

class AccountSettingsCoordinator = _AccountSettingsCoordinatorBase
    with _$AccountSettingsCoordinator;

abstract class _AccountSettingsCoordinatorBase with Store {
  final AccountSettingsWidgetsCoordinator widgets;

  _AccountSettingsCoordinatorBase({
    required this.widgets,
  });
}
