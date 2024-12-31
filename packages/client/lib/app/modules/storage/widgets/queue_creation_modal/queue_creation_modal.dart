import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/modules/session_content/widgets/widgets.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'queue_creation_modal_store.dart';

class QueueCreationModal extends HookWidget {
  final NokhteBlurStore blur;
  final ScrollController scrollController;
  final TextEditingController queueTitleController;
  final GroupDisplaySessionCardStore groupDisplaySessionCard;
  final FocusNode queueTitleFocusNode;
  final bool isManualSelected;
  final Function(bool) toggleSelectionMode;
  final Function(int) editItem;
  final Function(int) deleteItem;
  final Function(String) onTitleChanged;
  final List<String> queueItems;
  final Function(int oldIndex, int newIndex) reorderQueueItems;
  final BlockTextDisplayStore blockTextDisplay;

  const QueueCreationModal({
    super.key,
    required this.blur,
    required this.scrollController,
    required this.queueTitleController,
    required this.groupDisplaySessionCard,
    required this.queueTitleFocusNode,
    required this.isManualSelected,
    required this.toggleSelectionMode,
    required this.editItem,
    required this.deleteItem,
    required this.onTitleChanged,
    required this.queueItems,
    required this.reorderQueueItems,
    required this.blockTextDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return MultiHitStack(
      children: [
        NokhteBlur(
          store: blur,
        ),
        SingleChildScrollView(
          controller: scrollController,
          child: Observer(
            builder: (context) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Queue Title TextField (unchanged)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        controller: queueTitleController,
                        style: GoogleFonts.chivo(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w200,
                        ),
                        maxLines: 1,
                        maxLength: 30,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.go,
                        textAlign: TextAlign.center,
                        focusNode: queueTitleFocusNode,
                        onChanged: onTitleChanged,
                        decoration: InputDecoration(
                          hintText: 'QUEUE TITLE',
                          hintStyle: GoogleFonts.chivo(
                            color: Colors.white.withOpacity(.5),
                          ),
                          counterStyle: GoogleFonts.chivo(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),

                    BlockTextDisplay(
                      store: blockTextDisplay,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BlockTextFields(
          store: blockTextDisplay.blockTextFields,
        ),
      ],
    );
  }
}
