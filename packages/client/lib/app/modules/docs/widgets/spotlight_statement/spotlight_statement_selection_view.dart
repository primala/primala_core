import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class SpotlightStatementSelectionView extends HookWidget {
  final ValueNotifier<ContentBlockType?> selectedType;
  final ValueNotifier<bool> showTextField;
  final Animation<double> selectionOpacity;
  final Function(ContentBlockType) onBlockTypeUpdated;

  const SpotlightStatementSelectionView({
    super.key,
    required this.selectedType,
    required this.showTextField,
    required this.selectionOpacity,
    required this.onBlockTypeUpdated,
  });

  List<Widget> _buildContentTypeButtons(
    ValueNotifier<ContentBlockType?> selectedType,
    ValueNotifier<bool> showTextField,
  ) {
    final contentTypes = ContentBlockType.values.where(
      (type) =>
          type != ContentBlockType.conclusion && type != ContentBlockType.none,
    );

    return contentTypes
        .map(
          (type) => GestureDetector(
            onTap: () {
              selectedType.value = type;
              onBlockTypeUpdated(type);
              showTextField.value = true;
            },
            child: Column(
              children: [
                Image.asset(
                  BlockTextConstants.getAssetPath(type),
                  width: 37,
                  height: 37,
                ),
                Jost(
                  BlockTextConstants.getName(type),
                  fontSize: 12,
                  fontColor: Colors.black.withOpacity(.6),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: selectionOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 16,
                ),
                child: Jost(
                  'Spotlight Statement',
                  fontSize: 20,
                  fontColor: Colors.black.withOpacity(.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _buildContentTypeButtons(selectedType, showTextField),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
