import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'widgets.dart';

class PurposeConclusionBody extends StatelessWidget {
  final Function(int) onPurposeTap;
  final Function(int) onQueueTap;
  final ObservableList<String> sessionContent;

  const PurposeConclusionBody({
    super.key,
    required this.sessionContent,
    required this.onQueueTap,
    required this.onPurposeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final parsedData = _parseSessionContent(sessionContent);
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Render Queue Groups first
            ...parsedData.map((group) {
              final absoluteIndex = group["index"];
              return group.containsKey("Q")
                  ? QueueGroup(
                      onTap: onQueueTap,
                      queue: group["Q"]!.first,
                      index: absoluteIndex,
                    )
                  : PurposeWithConclusions(
                      onTap: onPurposeTap,
                      purpose: group["P"]!.first,
                      conclusions: group["C"]!,
                      index: absoluteIndex,
                    );
            }),

            SizedBox(
              height: bottomPadding + 80,
            ),
          ],
        ),
      );
    });
  }

  List<Map<String, dynamic>> _parseSessionContent(List<String> content) {
    List<Map<String, dynamic>> parsed = [];
    Map<String, dynamic> currentGroup = {};

    for (var i = 0; i < content.length; i++) {
      final line = content[i];
      if (line.startsWith("P: ")) {
        if (currentGroup.isNotEmpty) parsed.add(currentGroup);
        currentGroup = {
          "P": [line.substring(3)],
          "C": [],
          "index": i,
        };
      } else if (line.startsWith("C: ")) {
        currentGroup["C"].add(line.substring(3));
      } else if (line.startsWith("Q: ")) {
        if (currentGroup.isNotEmpty) parsed.add(currentGroup);
        currentGroup = {
          "Q": [line.substring(3)],
          "index": i,
        };
      }
    }

    if (currentGroup.isNotEmpty) parsed.add(currentGroup);

    print('Parsed data: $parsed');
    return parsed;
  }
}

class QueueGroup extends StatelessWidget {
  final Function(int) onTap;
  final String queue;
  final int index;

  const QueueGroup({
    super.key,
    required this.queue,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            spacing: 0,
            padding: EdgeInsets.zero,
            onPressed: (_) => onTap(index),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            icon: Icons.keyboard_arrow_down,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8A4FFF), // Deep Purple
                      Color(0xFFCB93FF), // Light Purple
                    ],
                    stops: [0, 1],
                  ),
                ),
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(16.0),
              //   gradient: const LinearGradient(
              //     colors: [
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              // ),
              child: Jost(
                queue,
                fontSize: 16,
                // color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
