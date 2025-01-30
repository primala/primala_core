import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'home_screen_coordinator.dart';

class HomeScreen extends HookWidget {
  final HomeScreenCoordinator coordinator;

  const HomeScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        child: Column(
          children: [
            HeaderRow(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: GestureDetector(
                    onTap: () async => await coordinator.clearActiveGroup(),
                    child: GroupAvatar(
                      groupName: coordinator.selectedGroup.name,
                      profileGradient:
                          coordinator.selectedGroup.profileGradient,
                      size: 60,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
