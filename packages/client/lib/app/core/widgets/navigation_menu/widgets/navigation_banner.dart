import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class NavigationBanner extends HookWidget {
  final bool swipeDownBannerVisibility;
  final bool swipeUpBannerVisibility;
  const NavigationBanner({
    super.key,
    required this.swipeDownBannerVisibility,
    required this.swipeUpBannerVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final size = useScaledSize(
      baseValue: .07,
      screenSize: useFullScreenSize(),
      bumpPerHundredth: 0.0001,
    );
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: useWidgetOpacity(swipeDownBannerVisibility),
          duration: Seconds.get(1),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size),
                child: Center(
                  child: Jost(
                    "Swipe down to navigate",
                    fontSize: size * .3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size * .06),
                child: Image.asset(
                  'assets/rounded_triangle.png',
                  width: size * .4,
                  height: size * .4,
                ),
              ),
            ],
          ),
        ),
        AnimatedOpacity(
          opacity: useWidgetOpacity(swipeUpBannerVisibility),
          duration: Seconds.get(1),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size),
                child: Center(
                  child: Jost(
                    "Swipe up to dismiss",
                    fontSize: size * .3,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: size * .06),
                  child: Image.asset(
                    'assets/rounded_triangle.png',
                    width: size * .4,
                    height: size * .4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
