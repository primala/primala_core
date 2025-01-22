import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_picker_coordinator.dart';
export 'group_picker_widgets_coordinator.dart';

class GroupPickerScreen extends HookWidget {
  final GroupPickerCoordinator coordinator;
  const GroupPickerScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return AnimatedScaffold(
      store: coordinator.widgets.animatedScaffold,
      child: Observer(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderRow(
              children: [
                InboxIcon(
                  showWidget: coordinator.widgets.showWidgets,
                  onTap: () {
                    print('inbox on top ');
                  },
                  badgeCount: 90,
                ),
                SmartHeader(
                  content: "Groups",
                  showWidget: coordinator.widgets.showWidgets,
                ),
                SettingsIcon(
                  showWidget: coordinator.widgets.showWidgets,
                  onTap: () {
                    print('settings on top ');
                  },
                ),
              ],
            ),
          ],
        );
      }),
      //
    );
  }
}
