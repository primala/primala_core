import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'invite_to_group_coordinator.dart';
export 'invite_to_group_widgets_coordinator.dart';

class InviteToGroupScreen extends HookWidget {
  final InviteToGroupCoordinator coordinator;
  const InviteToGroupScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        store: coordinator.widgets.animatedScaffold,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        ),
      );
    });
  }
}
