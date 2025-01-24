import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'create_group_coordinator.dart';
export 'create_group_widgets_coordinator.dart';

class CreateGroupScreen extends HookWidget {
  final CreateGroupCoordinator coordinator;
  const CreateGroupScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        store: coordinator.widgets.animatedScaffold,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                HeaderRow(
                  includeDivider: true,
                  children: [
                    LeftChevron(
                      onTap: coordinator.onGoBack,
                    ),
                    const SmartHeader(
                      content: "Create Group",
                    ),
                    const LeftChevron(
                      color: NokhteColors.eggshell,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
