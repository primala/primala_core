import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class DocHeader extends HookWidget with DialogueUtils {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final Function onBackPress;
  final Function? onTrashPressed;

  const DocHeader({
    super.key,
    required this.onChanged,
    required this.onBackPress,
    this.onTrashPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? useTextEditingController();
    final focusNode = useFocusNode();
    final screenHeight = useFullScreenSize().height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * .1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LeftChevron(
            onTap: () => onBackPress(),
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
                onChanged: onChanged,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
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
          if (onTrashPressed != null)
            Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () => showDeleteConfirmationDialog(
                    context: context,
                    onConfirm: onTrashPressed!,
                    title: 'Delete Document',
                    content: 'Are you sure you want to delete this document?',
                  ),
                  child: Image.asset(
                    'assets/groups/trash_icon_white.png',
                    color: Colors.black,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
          if (onTrashPressed == null)
            const LeftChevron(color: Colors.transparent)
        ],
      ),
    );
  }
}
