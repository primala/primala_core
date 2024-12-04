import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'navigation_menu_store.dart';
export 'types/types.dart';
export 'widgets/widgets.dart';
export 'widgets/navigation_beach_waves/stepwise_beach_waves_painter.dart';

// Example Usage with MobX Observer
class NavigationMenu extends HookWidget with ArticleBodyUtils {
  final NavigationMenuStore store;
  final BeachWavesStore beachWaves;
  final Widget? inBetweenWidgets;
  final bool useJustTheSlideAction;

  NavigationMenu({
    super.key,
    required this.store,
    this.inBetweenWidgets,
    this.useJustTheSlideAction = false,
  }) : beachWaves = store.beachWaves;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.constructor();
      return null;
    }, []);

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
              return Swipe(
                store: store.swipe,
                child: MultiHitStack(
                  children: [
                    Observer(builder: (context) {
                      return useJustTheSlideAction
                          ? Container()
                          : NavigationBeachWaves(
                              gradients:
                                  store.configuration.carouselInfo.gradients,
                              currentPosition: store.carouselPosition,
                              movie: value,
                            );
                    }),
                    Observer(builder: (context) {
                      return Opacity(
                        opacity: interpolate(
                          currentValue: store.carouselPosition,
                          targetValue:
                              store.configuration.startIndex.toDouble(),
                          minOutput: 0,
                          maxOutput: 1.0,
                        ),
                        child: inBetweenWidgets ?? Container(),
                      );
                    }),
                    Tint(
                      store: store.tint,
                    ),
                    NokhteBlur(
                      store: store.blur,
                    ),
                    Observer(builder: (context) {
                      return AnimatedOpacity(
                        opacity: useWidgetOpacity(store.showWidget),
                        duration: Seconds.get(1),
                        child: MultiHitStack(
                          children: [
                            NavigationBanner(
                              swipeDownBannerVisibility:
                                  store.swipeDownBannerVisibility,
                              swipeUpBannerVisibility:
                                  store.swipeUpBannerVisibility,
                            ),
                            AnimatedOpacity(
                              duration: Seconds.get(1),
                              opacity: useWidgetOpacity(
                                  store.swipeUpBannerVisibility),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 100.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ...store.configuration.sliderInfo.map(
                                          (sliderConfig) =>
                                              GeneralizedActionSlider(
                                            showWidget:
                                                store.swipeUpBannerVisibility,
                                            assetPath: sliderConfig.assetPath,
                                            sliderText: sliderConfig.sliderText,
                                            onSlideComplete: () {
                                              if (!store.showWidget) return;
                                              sliderConfig.callback();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  useJustTheSlideAction
                                      ? Container()
                                      : NavigationCarousel(
                                          carouselItems: store.configuration
                                              .carouselInfo.labels,
                                          initialPosition:
                                              store.configuration.startIndex,
                                          onScrolled: store.setCarouselPosition,
                                          isScrollEnabled:
                                              store.swipeUpBannerVisibility &&
                                                  store.showWidget,
                                          currentPosition:
                                              store.carouselPosition,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            });
      },
    );
  }
}
