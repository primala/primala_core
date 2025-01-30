import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_picker_coordinator.dart';

class GroupPickerScreen extends HookWidget {
  final GroupPickerCoordinator coordinator;
  const GroupPickerScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderRow(
                children: [
                  InboxIcon(
                    onTap: coordinator.onInboxTapped,
                    badgeCount: coordinator.inboxBadgeCount,
                  ),
                  const SmartHeader(
                    content: "Groups",
                  ),
                  SettingsIcon(
                    showWidget: true,
                    onTap: coordinator.onSettingsTapped,
                  ),
                ],
              ),
              GroupDisplay(
                store: coordinator.groupDisplay,
              ),
            ],
          ),
        ),
        //
      );
    });
  }
}
