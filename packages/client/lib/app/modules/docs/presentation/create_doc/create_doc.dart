import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
export 'create_doc_coordinator.dart';

class CreateDocScreen extends HookWidget {
  final CreateDocCoordinator coordinator;

  const CreateDocScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = useFullScreenSize().height;
    return Observer(builder: (context) {
      return AnimatedScaffold(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DocHeader(
            onBackPress: () => Modular.to.pop(),
            onChanged: coordinator.setTitle,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * .25),
            child: SpotlightStatement(
              onTextUpdated: coordinator.setSpotlightTextContent,
              onBlockTypeUpdated: coordinator.setBlockType,
            ),
          ),
          GenericButton(
            isEnabled: coordinator.canSubmit,
            label: "Create",
            onPressed: coordinator.submit,
            borderRadius: 10,
          )
        ],
      );
    });
  }
}
