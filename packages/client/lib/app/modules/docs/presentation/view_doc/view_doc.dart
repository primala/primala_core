import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
export 'view_doc_coordinator.dart';

class ViewDocScreen extends HookWidget {
  final ViewDocCoordinator coordinator;

  const ViewDocScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return const CarouselScaffold(
        initialPosition: 2,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmartHeader(
                content: "Documents",
              ),
            ],
          ),
        ],
      );
    });
  }
}
