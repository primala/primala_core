// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
part 'settings_coordinator.g.dart';

class SettingsCoordinator = _SettingsCoordinatorBase with _$SettingsCoordinator;

abstract class _SettingsCoordinatorBase with Store {
  final SettingsWidgetsCoordinator widgets;
  final SettingsContract logic;

  _SettingsCoordinatorBase({
    required this.widgets,
    required this.logic,
  });

  @action
  constructor() {
    widgets.constructor();
  }

  @action
  onYes() {
    widgets.onYes(() async {
      await logic.logOut();
    });
  }

  @action
  onNo() {
    widgets.onNo();
  }
}
