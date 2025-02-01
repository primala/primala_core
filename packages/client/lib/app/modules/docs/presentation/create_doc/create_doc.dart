import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
export 'create_doc_coordinator.dart';

class CreateDocsScreen extends HookWidget {
  final CreateDocCoordinator coordinator;

  const CreateDocsScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return const AnimatedScaffold(
        isScrollable: true,
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
