import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class SpotlightStatementTextField extends StatelessWidget {
  const SpotlightStatementTextField({
    super.key,
    required this.onTextUpdated,
    required this.type,
    required this.onBackPressed,
    required this.textFieldOpacity,
    required this.controller,
    required this.focusNode,
    required this.fontColor,
  });

  final Function(String p1) onTextUpdated;
  final ContentBlockType type;
  final Function onBackPressed;
  final Animation<double> textFieldOpacity;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: textFieldOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: BlockTextConstants.getGradient(
                type,
              ),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                    onBackPressed();
                  },
                  child: Image.asset(
                    BlockTextConstants.getAssetPath(type),
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              TextField(
                maxLines: null,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (value) => onTextUpdated(value),
                onTapOutside: (event) => focusNode.unfocus(),
                controller: controller,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  color: fontColor,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText:
                      'Enter your ${BlockTextConstants.getName(type).toLowerCase()}...',
                  hintStyle: TextStyle(
                    color: fontColor.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
