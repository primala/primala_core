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
      return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        body: MultiHitStack(
          children: [
            SingleChildScrollView(
              controller: coordinator.scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DocHeader(
                    onBackPress: coordinator.onBackPress,
                    onChanged: coordinator.onTitleChanged,
                    onTrashPressed: coordinator.onTrashPressed,
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
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Jost(
                      '${coordinator.characterCount}/2000',
                      fontSize: 14,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  BlockTextDisplay(
                    store: coordinator.blockTextDisplay,
                  ),
                ],
              ),
            ),
            BlockTextFields(
              store: coordinator.blockTextFields,
            ),
          ],
        ),
      );
    });
  }
}
