import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'information_coordinator.dart';

class InformationScreen extends HookWidget {
  final InformationCoordinator coordinator;

  const InformationScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderRow(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
            ],
          ),
        ],
      );
    });
  }
}
