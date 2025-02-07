import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class DocHeader extends HookWidget {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final Function onBackPress;

  const DocHeader({
    super.key,
    required this.onChanged,
    required this.onBackPress,
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
          const LeftChevron(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
