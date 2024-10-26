import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RichJostList extends StatelessWidget {
  final List<String> contentList;
  final bool isOrdered;
  final double horizontalPadding;

  jost({
    bool isBold = false,
  }) =>
      GoogleFonts.jost(
        fontSize: 16.0,
        fontWeight: isBold ? FontWeight.w400 : FontWeight.w300,
        color: Colors.white,
      );

  const RichJostList({
    super.key,
    required this.contentList,
    required this.isOrdered,
    this.horizontalPadding = 65.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: contentList.asMap().entries.map((entry) {
          int index = entry.key;
          String content = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOrdered ? '${index + 1}. ' : '• ',
                  style: jost(),
                ),
                Expanded(
                  child: RichText(
                    text: _parseBoldText(content),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  TextSpan _parseBoldText(String content) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final matches = regex.allMatches(content);

    if (matches.isEmpty) {
      return TextSpan(
        text: content,
        style: jost(),
      );
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: content.substring(lastMatchEnd, match.start),
            style: jost(),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: jost(isBold: true),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < content.length) {
      spans.add(
        TextSpan(
          text: content.substring(lastMatchEnd),
          style: jost(),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
