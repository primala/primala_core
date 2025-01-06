// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
part 'settings_coordinator.g.dart';

class SettingsCoordinator = _SettingsCoordinatorBase with _$SettingsCoordinator;

abstract class _SettingsCoordinatorBase with Store, Reactions {
  final SettingsWidgetsCoordinator widgets;
  final SettingsContract logic;
  final UserInformationCoordinator userInformation;

  _SettingsCoordinatorBase({
    required this.widgets,
    required this.logic,
    required this.userInformation,
  });

  @action
  constructor() async {
    widgets.constructor();
    disposers.add(userInformationReactor());
    disposers.add(deactivateAccountReactor());
    await userInformation.getUserInformation();
  }

  userInformationReactor() =>
      reaction((p0) => userInformation.userInformation, (p0) {
        widgets.setUserInformation(p0);
      });

  deactivateAccountReactor() =>
      reaction((p0) => widgets.settingsLayout.tapCount, (p0) {
        onYes();
      });

  @action
  onYes() {
    widgets.onYes(() async {
      await logic.logOut();
    });
  }

  @override
  @action
  dispose() {
    super.dispose();
    widgets.dispose();
  }
}
