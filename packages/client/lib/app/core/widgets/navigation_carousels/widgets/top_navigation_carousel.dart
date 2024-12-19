import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class TopNavigationCarousel extends HookWidget with ArticleBodyUtils {
  final List<String> carouselItems;
  final Function(double) onScrolled;
  final bool isScrollEnabled;
  final int initialPosition;
  final double currentPosition;

  const TopNavigationCarousel({
    super.key,
    required this.carouselItems,
    required this.onScrolled,
    required this.isScrollEnabled,
    required this.initialPosition,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = useFullScreenSize().height * 0.2;

    return Padding(
      padding: EdgeInsets.only(top: containerSize * .8),
      child: CarouselSlider(
        options: CarouselOptions(
          // pageSnapping: false,
          height: containerSize * 0.25,
          scrollPhysics:
              isScrollEnabled ? null : const NeverScrollableScrollPhysics(),

          viewportFraction: 0.35,
          initialPage: initialPosition.toInt(),
          enableInfiniteScroll: false,
          onScrolled: (double? value) => onScrolled(value ?? 0),
        ),
        items: List.generate(carouselItems.length, (index) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Measure text size
              final textSpan = TextSpan(
                text: carouselItems[index],
                style: TextStyle(
                  fontSize: containerSize * 0.1,
                  fontWeight: FontWeight.w300,
                ),
              );
              final textPainter = TextPainter(
                text: textSpan,
                textDirection: TextDirection.ltr,
              )..layout();

              // Add padding for the container
              final containerWidth = textPainter.width + 20;

              return Opacity(
                opacity: interpolate(
                  currentValue: currentPosition,
                  targetValue: index.toDouble(),
                  minOutput: 0.5,
                  maxOutput: 1.0,
                ),
                child: Container(
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      carouselItems[index],
                      style: TextStyle(
                        fontSize: containerSize * 0.1,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
