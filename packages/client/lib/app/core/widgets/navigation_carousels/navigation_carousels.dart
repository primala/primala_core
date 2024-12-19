import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'navigation_carousels_store.dart';
export 'types/types.dart';
export 'widgets/widgets.dart';
// export 'widgets/navigation_beach_waves/stepwise_beach_waves_painter.dart';

class NavigationCarousels extends HookWidget with ArticleBodyUtils {
  final NavigationCarouselsStore store;
  final BeachWavesStore beachWaves;
  final Widget? inBetweenWidgets;
  final bool useJustTheSlideAction;

  NavigationCarousels({
    super.key,
    required this.store,
    this.inBetweenWidgets,
    this.useJustTheSlideAction = false,
  }) : beachWaves = store.beachWaves;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.constructor();
      return () => store.dispose();
    }, []);
    final containerSize = useFullScreenSize().height * 0.2;

    return Observer(
      builder: (context) {
        return NokhteCustomAnimationBuilder(
            control: useJustTheSlideAction
                ? Control.stop
                : beachWaves.currentControl,
            duration: beachWaves.currentMovie.duration,
            tween: beachWaves.currentMovie,
            onCompleted: () => beachWaves.onCompleted(),
            builder: (context, value, child) {
              return MultiHitStack(
                children: [
                  Observer(builder: (context) {
                    return useJustTheSlideAction
                        ? Container()
                        : NavigationBeachWaves(
                            gradients: store.configuration.gradients,
                            currentPosition: store.carouselPosition,
                            movie: value,
                          );
                  }),
                  Observer(builder: (context) {
                    return Opacity(
                      opacity: interpolate(
                        currentValue: store.carouselPosition,
                        targetValue: store.configuration.startIndex.toDouble(),
                        minOutput: 0,
                        maxOutput: 1.0,
                      ),
                      child: inBetweenWidgets ?? Container(),
                    );
                  }),
                  Observer(builder: (context) {
                    return AnimatedOpacity(
                      opacity: useWidgetOpacity(store.showWidget),
                      duration: Seconds.get(0, milli: 500),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TopNavigationCarousel(
                            carouselItems: store.configuration.labels,
                            initialPosition: store.configuration.startIndex,
                            onScrolled: store.setCarouselPosition,
                            isScrollEnabled: store.canScroll,
                            currentPosition: store.carouselPosition,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 0.0,
                              top: 10,
                            ),
                            child: CarouselPlacementIndicator(
                              length: store.configuration.labels.length,
                              currentPosition: store.carouselPosition,
                              containerSize: containerSize,
                            ),
                          ),
                          Opacity(
                            opacity: interpolate(
                              currentValue: store.carouselPosition,
                              targetValue:
                                  store.configuration.startIndex.toDouble(),
                              minOutput: 0,
                              maxOutput: 1.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    store.configuration.sections.map((element) {
                                  // Add padding to all items except the last one
                                  final isLastItem = store
                                          .configuration.sections
                                          .indexOf(element) ==
                                      store.configuration.sections.length - 1;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: isLastItem
                                            ? 0
                                            : 16.0), // Add padding between items
                                    child: NavigationCarouselsSectionIcon(
                                      isSelected:
                                          store.currentlySelectedSection ==
                                              element.type,
                                      onTap: (type) {
                                        store.setCurrentlySelectedSection(type);
                                        // print("Tapped section ${element.key}");
                                      },
                                      type: element.type,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              );
            });
      },
    );
  }
}
