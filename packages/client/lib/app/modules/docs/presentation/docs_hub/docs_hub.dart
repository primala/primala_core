import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
export 'docs_hub_coordinator.dart';

class DocsHubScreen extends HookWidget {
  final DocsHubCoordinator coordinator;

  const DocsHubScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () async => await coordinator.dispose();
    }, []);

    return Observer(builder: (context) {
      return CarouselScaffold(
        initialPosition: 2,
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeaderRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmartHeader(
                content: "Documents",
              ),
            ],
          ),
          DocsDisplay(
            docs: coordinator.documents,
            onDocTapped: coordinator.onDocTapped,
            onCreateDocTapped: coordinator.onCreateDocTapped,
          )
        ],
      );
    });
  }
}
