import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
export 'carousel_placement_indicator.dart';

class NavigationCarousel extends HookWidget {
  final List<String> carouselItems;
  final List<Function> callbacks;
  final int initialPosition;

  const NavigationCarousel({
    super.key,
    required this.carouselItems,
    required this.callbacks,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = useFullScreenSize().height * .2;
    final currentPosition = useState(initialPosition.toDouble());
    useEffect(() {
      if (currentPosition.value != initialPosition &&
          currentPosition.value % 1 == 0) {
        callbacks[currentPosition.value.toInt()]();
      }
      return null;
    }, [currentPosition.value]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: containerSize * .2,
            aspectRatio: 1,
            viewportFraction: .28,
            initialPage: initialPosition.toInt(),
            enableInfiniteScroll: false,
            onScrolled: (value) => currentPosition.value = value ?? 0,
          ),
          items: List.generate(carouselItems.length, (index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Jost(
                carouselItems[index],
                fontSize: 20,
                fontWeight: FontWeight.w300,
                fontColor: Colors.black,
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
            currentPosition: currentPosition.value,
            containerSize: containerSize,
          ),
        ),
      ],
    );
  }
}
