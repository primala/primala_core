import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'purpose_with_conclusions_store.dart';
import 'swipable_tiles/swipable_tiles.dart';

class PurposeWithConclusions extends StatelessWidget {
  final PurposeWithConclusionsStore store = PurposeWithConclusionsStore();
  final Function(int) onTap;
  final String purpose;
  final List conclusions;
  final int index;

  PurposeWithConclusions({
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
    return SwipeableTile(
      isElevated: false,
      swipeThreshold: .2,
      swipeWidth: 400,
      direction: SwipeDirection.startToEnd,
      key: UniqueKey(),
      backgroundBuilder: (context, direction, progress) {
        return AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            store.setSwipeProgress(progress.value);
            return Row(
              children: [
                SizedBox(width: (progress.value * 50)), //
                Icon(
                  Icons.reply,
                  color: Colors.white,
                  size: progress.value * 250,
                ),
                SizedBox(
                    width: (progress.value * 100)), // Slides icon in from left
              ],
            );
          },
        );
      },
      color: Colors.transparent,
      onSwiped: (direction) {},
      confirmSwipe: (_) async {
        onTap(index);
        return false;
      },
      child: Observer(builder: (context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(left: store.swipeProgress * 100),
          // padding: EdgeInsets.all(padValue),
          duration: Duration.zero,
          curve: Curves.easeInOut,
          child: Container(
            margin: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
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
      }),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 3,
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
