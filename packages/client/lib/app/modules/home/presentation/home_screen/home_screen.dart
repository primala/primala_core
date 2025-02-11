import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
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
    }, []);
    final screenSize = useFullScreenSize().height;
    return Observer(builder: (context) {
      return CarouselScaffold(
        dispose: coordinator.dispose,
        showWidgets: coordinator.showWidgets,
        showCarousel: coordinator.showCarousel,
        mainAxisAlignment: MainAxisAlignment.start,
        initialPosition: 1,
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
                    profileGradient: coordinator.selectedGroup.profileGradient,
                    size: 60,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenSize * .18,
          ),
          HomeScreenBody(
            activeSession: coordinator.activeSession,
            startSession: coordinator.goToSessionStarter,
            joinSession: coordinator.joinSession,
          ),
        ],
      );
    });
  }
}
