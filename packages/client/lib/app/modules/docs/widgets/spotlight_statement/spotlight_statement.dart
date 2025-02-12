import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
export 'spotlight_statement_text_field.dart';
export 'spotlight_statement_selection_view.dart';

class SpotlightStatement extends HookWidget {
  final Function(String) onTextUpdated;
  final Function(ContentBlockType) onBlockTypeUpdated;
  final TextEditingController? controller;
  final ContentBlockType? externalBlockType;
  final bool showTextField;
  final double paddingValue;
  final Color fontColor;

  const SpotlightStatement({
    super.key,
    required this.onTextUpdated,
    required this.onBlockTypeUpdated,
    this.controller,
    this.externalBlockType,
    this.paddingValue = 0.5,
    this.showTextField = false,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final selectedType = useState<ContentBlockType?>(
        externalBlockType == ContentBlockType.none ? null : externalBlockType);
    final showTextField = useState(this.showTextField);
    final isInitiallyRendered = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1),
    );
    if (this.showTextField && !isInitiallyRendered.value) {
      animationController.animateTo(
        1.0,
        duration: Duration.zero,
      );
      isInitiallyRendered.value = true;
    }

    final selectionOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    final textFieldOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    useEffect(() {
      if (externalBlockType != null &&
          externalBlockType != selectedType.value) {
        selectedType.value = externalBlockType;
      }
      return null;
    }, [externalBlockType]);

    useEffect(() {
      if (showTextField.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [showTextField.value]);

    final screenHeight = useFullScreenSize().height;

    return Padding(
      // duration: const Duration(milliseconds: 300),
      padding: paddingValue == 0
          ? EdgeInsets.zero
          : EdgeInsets.only(
              bottom: showTextField.value
                  ? screenHeight * .02
                  : screenHeight * .0201,
            ),
      child: Stack(
        children: [
          if (!showTextField.value)
            SpotlightStatementSelectionView(
              color: fontColor,
              selectedType: selectedType,
              showTextField: showTextField,
              selectionOpacity: selectionOpacity,
              onBlockTypeUpdated: onBlockTypeUpdated,
            ),
          if (showTextField.value)
            SpotlightStatementTextField(
                fontColor: fontColor,
                onTextUpdated: onTextUpdated,
                type: selectedType.value!,
                onBackPressed: () {
                  showTextField.value = false;
                  if (!this.showTextField) {
                    onBlockTypeUpdated(ContentBlockType.none);
                  }
                },
                textFieldOpacity: textFieldOpacity,
                controller: controller ?? useTextEditingController(),
                focusNode: useFocusNode()),
        ],
      ),
    );
  }
}
