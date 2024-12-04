// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PresetKey extends HookWidget {
  const PresetKey({
    super.key,
  });

  getContainer(String text) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 15.0,
        ),
        child: Text(
          text,
          style: GoogleFonts.jost(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return FullScreen(
      child: Padding(
        padding: EdgeInsets.only(
          top: useScaledSize(
            baseValue: 0.13,
            bumpPerHundredth: -0.001,
            screenSize: screenSize,
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getContainer('Tap to explore'),
              Container(
                width: 1.5, // Width of the line
                height: 25.0, // Height of the line
                color: Colors.white, // Color of the line
              ),
              getContainer('Hold to select'),
            ]),
      ),
    );
  }
}
