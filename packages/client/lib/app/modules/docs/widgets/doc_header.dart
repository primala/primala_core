import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'block_text/block_text_display/context_menu/context_menu.dart';

class DocHeader extends HookWidget with DialogueUtils {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final Function? onBackPress;
  final Function? onTrashPressed;
  final Function? onArchivePressed;
  final Color color;
  final String text;
  final bool isArchived;

  const DocHeader({
    super.key,
    required this.onChanged,
    this.onBackPress,
    this.onTrashPressed,
    this.onArchivePressed,
    this.controller,
    this.text = '',
    this.isArchived = false,
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
                    enabled: !isArchived,
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
                onTapDown: (details) {
                  HapticFeedback.mediumImpact();
                  showContextMenu(
                    context,
                    contextMenu: ContextMenu(
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                      ),
                      entries: <ContextMenuEntry>[
                        MenuItem(
                          label: '${isArchived ? 'un' : ''}archive',
                          iconPath: 'assets/docs/archive_icon.png',
                          onSelected: () async {
                            await onArchivePressed?.call();
                          },
                        ),
                        MenuItem(
                          label: 'delete',
                          iconPath: 'assets/docs/trash_icon.png',
                          onSelected: () {
                            showDeleteConfirmationDialog(
                              context: context,
                              onConfirm: onTrashPressed!,
                              title: 'Delete Document',
                              content:
                                  'Are you sure you want to delete this document?',
                            );
                          },
                        ),
                      ],
                      position: details.globalPosition,
                      padding: const EdgeInsets.all(8.0),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/docs/ellipse_icon.png',
                    color: Colors.black,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
