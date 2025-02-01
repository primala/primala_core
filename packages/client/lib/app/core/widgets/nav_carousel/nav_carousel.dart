import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
export 'carousel_placement_indicator.dart';

class NavCarousel extends HookWidget {
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
    final containerSize = useFullScreenSize().height * .2;
    useEffect(() {
      if (currentPosition != initialPosition && currentPosition % 1 == 0) {
        callbacks[currentPosition.toInt()]();
      }
      return null;
    }, [currentPosition]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CarouselSlider(
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
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: isEnabled ? Colors.black : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Jost(
                carouselItems[index],
                fontSize: 20,
                fontWeight: FontWeight.w300,
                fontColor: isEnabled ? Colors.black : Colors.transparent,
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 35.0,
            top: 10,
          ),
          child: CarouselPlacementIndicator(
            length: carouselItems.length,
            currentPosition: currentPosition,
            containerSize: containerSize,
          ),
        ),
      ],
    );
  }
}
