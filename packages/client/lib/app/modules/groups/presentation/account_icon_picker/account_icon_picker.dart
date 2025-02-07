import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'account_icon_picker_coordinator.dart';
export 'account_icon_picker_widgets_coordinator.dart';

class AccountIconPickerScreen extends HookWidget {
  final AccountIconPickerCoordinator coordinator;
  const AccountIconPickerScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      //  coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return AnimatedScaffold(
      store: coordinator.widgets.animatedScaffold,
      children: const [],
    );
  }
}
