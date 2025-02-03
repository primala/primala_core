import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class SpotlightStatement extends HookWidget {
  final Function(String) onTextUpdated;
  final Function(ContentBlockType) onBlockTypeUpdated;

  const SpotlightStatement({
    super.key,
    required this.onTextUpdated,
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

  Widget _buildSelectionView(
    ValueNotifier<ContentBlockType?> selectedType,
    ValueNotifier<bool> showTextField,
    Animation<double> selectionOpacity,
  ) {
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

  Widget _buildTextFieldView(
    ContentBlockType type,
    VoidCallback onBackPressed,
    Animation<double> textFieldOpacity,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return FadeTransition(
      opacity: textFieldOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: MultiHitStack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  gradient: BlockTextConstants.getGradient(
                    type,
                  ),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                maxLines: null,
                onChanged: (value) => onTextUpdated(value),
                onTapOutside: (event) => focusNode.unfocus(),
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                    left: 44,
                    top: 16,
                    bottom: 16,
                  ),
                  border: InputBorder.none,
                  hintText:
                      'Enter your ${BlockTextConstants.getName(type).toLowerCase()}...',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 14,
              child: GestureDetector(
                onTap: () {
                  focusNode.unfocus();
                  onBackPressed();
                },
                child: Image.asset(
                  BlockTextConstants.getAssetPath(type),
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = useState<ContentBlockType?>(null);
    final showTextField = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1),
    );

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
      if (showTextField.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [showTextField.value]);

    final screenHeight = useFullScreenSize().height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * .25),
      child: Stack(
        children: [
          _buildSelectionView(selectedType, showTextField, selectionOpacity),
          if (selectedType.value != null)
            _buildTextFieldView(
              selectedType.value!,
              () {
                showTextField.value = false;
                onBlockTypeUpdated(ContentBlockType.none);
              },
              textFieldOpacity,
              useTextEditingController(),
              useFocusNode(),
            ),
        ],
      ),
    );
  }
}
