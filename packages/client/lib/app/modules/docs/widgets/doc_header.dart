import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class DocHeader extends HookWidget with DialogueUtils {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final Function? onBackPress;
  final Function? onTrashPressed;
  final Color color;
  final String text;

  const DocHeader({
    super.key,
    required this.onChanged,
    this.onBackPress,
    this.onTrashPressed,
    this.controller,
    this.text = '',
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? useTextEditingController();
    final focusNode = useFocusNode();
    final screenHeight = useFullScreenSize().height;
    return Padding(
      padding: EdgeInsets.only(
        top: onBackPress != null ? screenHeight * .1 : 0,
        bottom: onBackPress == null ? screenHeight * .01 : 0,
      ),
      child: MultiHitStack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onBackPress != null)
                LeftChevron(
                  onTap: () => onBackPress!(),
                ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textCapitalization: TextCapitalization.words,
                    onTapOutside: (event) => focusNode.unfocus(),
                    onChanged: onChanged,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jost(
                      color: color,
                      fontSize: 24,
                    ),
                    cursorColor: Colors.black,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Document Name',
                      hintStyle: GoogleFonts.jost(
                        color: color.withOpacity(0.5),
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
              if (onBackPress != null)
                const LeftChevron(color: Colors.transparent)
            ],
          ),
          if (onTrashPressed != null)
            Positioned(
              right: 10,
              top: 10,
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
        ],
      ),
    );
  }
}
