import 'package:flutter/material.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

mixin SwipeGuideUtils {
  double getRightPadding(Size screenSize, int i, List orientations) {
    if (orientations[i] == SwipeGuideOrientation.left) {
      return useScaledSize(
        baseValue: .05,
        screenSize: screenSize,
        bumpPerHundredth: .0004,
      );
    } else if (orientations[i] == SwipeGuideOrientation.top ||
        orientations[i] == SwipeGuideOrientation.bottom) {
      return useScaledSize(
        baseValue: .00,
        screenSize: screenSize,
        bumpPerHundredth: .00001,
      );
    } else {
      return 0;
    }
  }

  double getLeftPadding(Size screenSize, int i, List orientations) {
    if (orientations[i] == SwipeGuideOrientation.right) {
      return useScaledSize(
        baseValue: .05,
        screenSize: screenSize,
        bumpPerHundredth: .0004,
      );
    } else {
      return 0;
    }
  }

  double getBottomPadding(Size screenSize, int i, List orientations) {
    if (orientations[i] == SwipeGuideOrientation.left ||
        orientations[i] == SwipeGuideOrientation.right) {
      return useScaledSize(
        baseValue: .03,
        screenSize: screenSize,
        bumpPerHundredth: .0013,
      );
    } else if (orientations[i] == SwipeGuideOrientation.top) {
      return useScaledSize(
        baseValue: .08,
        screenSize: screenSize,
        bumpPerHundredth: .0018,
      );
    } else {
      // return 0;
      return useScaledSize(
        baseValue: .00001,
        screenSize: screenSize,
        bumpPerHundredth: .001,
      );
    }
  }

  double getTopPadding(Size screenSize, int i, List orientations) {
    if (orientations[i] == SwipeGuideOrientation.bottom) {
      return useScaledSize(
        baseValue: .02,
        screenSize: screenSize,
        bumpPerHundredth: .0001,
      );
    } else {
      return 0;
    }
  }

  List<Widget> buildGuides(
    Movie value,
    Size screenSize,
    List orientations,
  ) {
    final List<Widget> temp = [];
    for (int i = 0; i < orientations.length; i++) {
      double containerSize = useScaledSize(
        baseValue: .2,
        screenSize: screenSize,
        bumpPerHundredth: .00002,
      );
      temp.add(Center(
        child: Padding(
          padding: EdgeInsets.only(
            right: getRightPadding(screenSize, i, orientations),
            bottom: getBottomPadding(screenSize, i, orientations),
            left: getLeftPadding(screenSize, i, orientations),
            top: getTopPadding(screenSize, i, orientations),
          ),
          child: SizedBox(
            height: containerSize,
            width: containerSize,
            child: CustomPaint(
              painter: SwipeGuidePainter(
                orientation: orientations[i],
                opacities: [
                  value.get('o7'),
                  value.get('o6'),
                  value.get('o5'),
                  value.get('o4'),
                  value.get('o3'),
                  value.get('o2'),
                  value.get('o1'),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return temp;
  }
}
