import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class SpotlightStatement extends HookWidget {
  final Function(String) onTextUpdated;
  final TextEditingController? controller;
  final ContentBlockType? externalBlockType;
  final double paddingValue;

  const SpotlightStatement({
    super.key,
    required this.onTextUpdated,
    this.controller,
    this.externalBlockType,
    this.paddingValue = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = useFullScreenSize().height;
    final focusNode = useFocusNode();

    return Padding(
      padding: paddingValue == 0
          ? EdgeInsets.zero
          : EdgeInsets.only(
              bottom: screenHeight * .02,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0), // Deep Purple
                Color(0xFF363535), // Light Purple
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/blocks/nokhte_icon.png',
                  width: 35,
                  height: 35,
                ),
              ),
              TextField(
                maxLines: null,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                onChanged: (value) => onTextUpdated(value),
                onTapOutside: (event) => focusNode.unfocus(),
                controller: controller,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Enter your spotlight statement...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
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
