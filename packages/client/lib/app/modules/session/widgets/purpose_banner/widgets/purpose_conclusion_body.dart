import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'widgets.dart';

class PurposeConclusionBody extends StatelessWidget {
  final Function(int) onTap;
  final ObservableList<String> sessionContent;

  const PurposeConclusionBody({
    super.key,
    required this.sessionContent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final parsedData = _parseSessionContent(sessionContent);
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: parsedData.map((group) {
            final absoluteIndex = group["index"]; // Get the absolute index
            return PurposeWithConclusions(
              onTap: onTap, // Pass the absolute index
              purpose: group["P"]!.first,
              conclusions: group["C"]!,
              index: absoluteIndex,
            );
          }).toList(),
        ),
      );
    });
  }

  List<Map<String, dynamic>> _parseSessionContent(List<String> content) {
    List<Map<String, dynamic>> parsed = [];
    Map<String, dynamic> currentGroup = {"P": [], "C": [], "index": null};

    for (var i = 0; i < content.length; i++) {
      final line = content[i];
      if (line.startsWith("P: ")) {
        if (currentGroup["P"].isNotEmpty) parsed.add(currentGroup);
        currentGroup = {
          "P": [line.substring(3)],
          "C": [],
          "index": i, // Store the absolute index of the purpose
        };
      } else if (line.startsWith("C: ")) {
        currentGroup["C"].add(line.substring(3));
      }
    }
    if (currentGroup["P"].isNotEmpty) parsed.add(currentGroup);
    return parsed;
  }
}
