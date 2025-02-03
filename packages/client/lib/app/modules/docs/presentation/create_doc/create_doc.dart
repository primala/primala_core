import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    return Observer(builder: (context) {
      return AnimatedScaffold(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderRow(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LeftChevron(
                onTap: () => Modular.to.pop(),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onTapOutside: (event) => focusNode.unfocus(),
                    onChanged: coordinator.setTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jost(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    cursorColor: Colors.black,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Document Name',
                      hintStyle: GoogleFonts.jost(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const LeftChevron(
                color: Colors.transparent,
              ),
            ],
          ),
          SpotlightStatement(
            onTextUpdated: coordinator.setSpotlightTextContent,
            onBlockTypeUpdated: coordinator.setBlockType,
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
