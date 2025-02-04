import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';
export 'view_doc_coordinator.dart';

class ViewDocScreen extends HookWidget {
  final ViewDocCoordinator coordinator;
  final DocumentEntity doc;

  const ViewDocScreen({
    super.key,
    required this.coordinator,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(doc);
      return null;
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DocHeader(
            onChanged: coordinator.onTitleChanged,
            controller: coordinator.docTitleController,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SpotlightStatement(
              onTextUpdated: coordinator.onSpotlightTextChanged,
              onBlockTypeUpdated: coordinator.onBlockTypeChanged,
              controller: coordinator.spotlightController,
              externalBlockType: coordinator.spotlightContentBlock.type,
              showTextField: true,
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.black,
          )
        ],
      );
    });
  }
}
