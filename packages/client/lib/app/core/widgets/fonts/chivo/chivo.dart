import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chivo extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final String content;
  final bool shouldCenter;
  final bool shouldItalicize;
  final FontWeight fontWeight;

  const Chivo(
    this.content, {
    super.key,
    this.fontWeight = FontWeight.w200,
    this.fontSize = 30.0,
    this.fontColor = Colors.white,
    this.shouldItalicize = false,
    this.shouldCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: shouldCenter ? TextAlign.center : TextAlign.start,
      text: _parseBoldText(content),
    );
  }

  TextStyle chivo({
    bool isBold = false,
  }) =>
      GoogleFonts.chivo(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.w300 : fontWeight,
        color: fontColor,
        fontStyle: shouldItalicize ? FontStyle.italic : FontStyle.normal,
      );

  TextSpan _parseBoldText(String content) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final matches = regex.allMatches(content);

    if (matches.isEmpty) {
      return TextSpan(
        text: content,
        style: chivo(),
      );
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: content.substring(lastMatchEnd, match.start),
            style: chivo(),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: chivo(isBold: true),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < content.length) {
      spans.add(
        TextSpan(
          text: content.substring(lastMatchEnd),
          style: chivo(),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
