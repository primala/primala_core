import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Jost extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final String content;
  final bool shouldCenter;
  final bool shouldItalicize;
  final bool addShadow;
  final FontWeight fontWeight;
  final bool useEllipsis;
  const Jost(
    this.content, {
    super.key,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 30.0,
    this.addShadow = false,
    this.fontColor = Colors.white,
    this.shouldItalicize = false,
    this.shouldCenter = false,
    this.useEllipsis = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: shouldCenter ? TextAlign.center : null,
      // softWrap: true,
      style: GoogleFonts.jost(
        fontSize: fontSize,
        color: fontColor,
        textStyle: TextStyle(
          fontWeight: fontWeight,
          shadows: addShadow
              ? [
                  Shadow(
                    color: Colors.black.withOpacity(.5),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  )
                ]
              : [],
          fontStyle: shouldItalicize ? FontStyle.italic : FontStyle.normal,
          overflow: useEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
        ),
      ),
    );
  }
}
