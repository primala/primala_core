import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'account_settings_coordinator.dart';

class AccountSettingsScreen extends HookWidget {
  final AccountSettingsCoordinator coordinator;
  const AccountSettingsScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        store: coordinator.animatedScaffold,
        showWidgets: coordinator.showWidgets,
        children: [
          HeaderRow(
            title: "Settings",
            onChevronTapped: coordinator.onGoBack,
          ),
          SettingsLayout(
            canDeleteAccount: coordinator.canDeleteAccount,
            onDeleteAccount: coordinator.onDelete,
            user: coordinator.user,
            onNameChanged: coordinator.onNameChanged,
            onNameSubmit: coordinator.onNameSubmit,
            errorText: coordinator.nameErrorText,
            onGradientChanged: coordinator.onGradientChanged,
          ),
          // GroupNameTextField(
          //   store: coordinator.widgets.groupNameTextField,
          // ),
        ],
      );
    });
  }
}
