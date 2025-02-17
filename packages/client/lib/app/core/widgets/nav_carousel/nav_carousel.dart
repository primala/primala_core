import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
export 'carousel_placement_indicator.dart';

class NavCarousel extends HookWidget with OpacityUtils {
  final List<String> carouselItems;
  final List<Function> callbacks;
  final int initialPosition;
  final double currentPosition;
  final bool isEnabled;
  final Function(double) onPositionChanged;

  const NavCarousel(
      {super.key,
      required this.carouselItems,
      required this.callbacks,
      required this.initialPosition,
      required this.currentPosition,
      required this.onPositionChanged,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    final containerSize = useScaledSize(
      baseValue: 0.2,
      screenSize: screenSize,
      bumpPerHundredth: 0.001,
    );
    final textOpacity = useState<double>(0.0);

    showTextTemporarily() {
      textOpacity.value = 0.6;

      Timer(const Duration(seconds: 3), () {
        textOpacity.value = 0.0;
      });
    }

    useEffect(() {
      if (currentPosition != initialPosition && currentPosition % 1 == 0) {
        callbacks[currentPosition.toInt()]();
      }
      return null;
    }, [currentPosition]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: textOpacity.value,
          duration: const Duration(milliseconds: 250),
          child: const Jost(
            'Swipe to Navigate',
            fontColor: Colors.black,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 14),
          // height: containerSize * .2,
          color: NokhteColors.eggshell,
          child: CarouselSlider(
            options: CarouselOptions(
              scrollPhysics:
                  isEnabled ? null : const NeverScrollableScrollPhysics(),
              height: containerSize * .2,
              aspectRatio: 1,
              viewportFraction: .28,
              initialPage: initialPosition.toInt(),
              enableInfiniteScroll: false,
              onScrolled: (value) => onPositionChanged(value ?? 0),
            ),
            items: List.generate(carouselItems.length, (index) {
              return GestureDetector(
                onTap: isEnabled ? showTextTemporarily : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(
                      color: isEnabled
                          ? Colors.black.withOpacity(interpolate(
                              currentValue: currentPosition,
                              targetValue: index.toDouble(),
                              minOutput: 0.5,
                              maxOutput: 1.0,
                            ))
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Jost(
                    carouselItems[index],
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    fontColor: isEnabled
                        ? Colors.black.withOpacity(interpolate(
                            currentValue: currentPosition,
                            targetValue: index.toDouble(),
                            minOutput: 0.5,
                            maxOutput: 1.0,
                          ))
                        : Colors.transparent,
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          color: NokhteColors.eggshell,
          height: useScaledSize(
            baseValue: 0.02,
            screenSize: screenSize,
            bumpPerHundredth: 0.0001,
          ),
        ),
        CarouselPlacementIndicator(
          color: isEnabled ? Colors.black : Colors.transparent,
          length: carouselItems.length,
          currentPosition: currentPosition,
          containerSize: containerSize,
        ),
        Container(
          color: NokhteColors.eggshell,
          height: useScaledSize(
            baseValue: 0.05,
            screenSize: screenSize,
            bumpPerHundredth: -0.0008,
          ),
        )
      ],
    );
  }
}
