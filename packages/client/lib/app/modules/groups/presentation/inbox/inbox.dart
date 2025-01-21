import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'inbox_coordinator.dart';
export 'inbox_widgets_coordinator.dart';

class InboxScreen extends HookWidget {
  final InboxCoordinator coordinator;
  const InboxScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      //  coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return AnimatedScaffold(
      store: coordinator.widgets.animatedScaffold,
      child: Observer(builder: (context) {
        return MultiHitStack(
          children: [],
        );
      }),
    );
  }
}
