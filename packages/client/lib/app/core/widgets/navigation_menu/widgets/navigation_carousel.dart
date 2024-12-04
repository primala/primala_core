import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class NavigationCarousel extends HookWidget {
  final List<String> carouselItems;
  final Function(double) onScrolled;
  final bool isScrollEnabled;
  final int initialPosition;
  final double currentPosition;

  const NavigationCarousel({
    super.key,
    required this.carouselItems,
    required this.onScrolled,
    required this.isScrollEnabled,
    required this.initialPosition,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = useFullScreenSize().height * .2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: containerSize * .29,
            scrollPhysics:
                isScrollEnabled ? null : const NeverScrollableScrollPhysics(),
            aspectRatio: 1,
            viewportFraction: .28,
            initialPage: initialPosition.toInt(),
            enableInfiniteScroll: false,
            onScrolled: (double? value) => onScrolled(value ?? 0),
          ),
          items: List.generate(carouselItems.length, (index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  carouselItems[index],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
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
