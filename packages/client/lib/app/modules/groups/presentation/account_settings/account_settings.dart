import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'account_settings_coordinator.dart';
export 'account_settings_widgets_coordinator.dart';

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
        child: Column(
          children: [
            HeaderRow(
              includeDivider: false,
              children: [
                LeftChevron(
                  onTap: coordinator.onGoBack,
                ),
                const SmartHeader(
                  content: "Settings",
                ),
                const LeftChevron(
                  color: Colors.transparent,
                ),
              ],
            ),
            SettingsLayout(
              onDeactivate: coordinator.onDeactivate,
              user: coordinator.user,
            ),
            // GroupNameTextField(
            //   store: coordinator.widgets.groupNameTextField,
            // ),
          ],
        ),
      );
    });
  }
}
