import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class TagLine extends HookWidget {
  final String text;
  final bool useExpandedPadding;
  final bool shouldGiveMoreSpaceToTheRight;
  final TextStyle textStyle = GoogleFonts.jost(
    fontSize: 15,
  );

  TagLine(
    this.text, {
    this.useExpandedPadding = true,
    this.shouldGiveMoreSpaceToTheRight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Builder(builder: (context) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(
        maxWidth: screenSize.width,
      );

      double textHeight = textPainter.size.height;

      return SizedBox(
        height: textHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: useExpandedPadding ? 40 : 30),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Container(
                width: 2,
                height: textHeight - 5,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Jost(
                text,
                shouldItalicize: true,
                fontSize: 15,
              ),
            ),
            SizedBox(
              width: useScaledSize(
                baseValue: shouldGiveMoreSpaceToTheRight ? .054 : .094,
                screenSize: screenSize,
                bumpPerHundredth: -0.001,
              ),
            ),
          ],
        ),
      );
    });
  }
}
