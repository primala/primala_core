import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
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
      //  coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return AnimatedScaffold(
      showWidgets: coordinator.showWidgets,
      child: Column(
        children: [
          HeaderRow(children: [
            // GroupAvatar()
          ])
        ],
      ),
    );
  }
}
