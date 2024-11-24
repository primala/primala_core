import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'widgets.dart';

class PurposeWithConclusions extends StatelessWidget {
  final Function(int) onTap; // Use absolute index
  final String purpose;
  final List conclusions;
  final int index;

  const PurposeWithConclusions({
    super.key,
    required this.purpose,
    required this.conclusions,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: ConnectionPainter(conclusions.length),
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPurposeBox(),
              ..._buildConclusions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeBox() {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            spacing: 0,
            padding: EdgeInsets.zero,
            onPressed: (_) =>
                onTap(index), // Call onTap with the absolute index
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            icon: Icons.reply,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81FFE2),
                Color(0xFF0082FB),
              ],
              stops: [0, 1],
            ),
          ),
        ),
        child: Jost(
          purpose,
          fontSize: 16,
        ),
      ),
    );
  }

  List<Widget> _buildConclusions() {
    return conclusions
        .asMap()
        .entries
        .map((entry) => Container(
              margin: const EdgeInsets.only(
                left: 40.0,
                right: 16.0,
                top: 8.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF4646),
                      Color(0xFFFFAA00),
                    ],
                    stops: [0, 1],
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Jost(
                  entry.value,
                  fontSize: 16,
                ),
              ),
            ))
        .toList();
  }
}
