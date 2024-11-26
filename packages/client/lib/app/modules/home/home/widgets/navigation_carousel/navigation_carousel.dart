import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/extensions/double.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/home/home/home.dart';
import 'package:nokhte/app/modules/session_joiner/session_joiner.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:action_slider/action_slider.dart';
export 'navigation_carousel_store.dart';

class NavigationCarousel extends HookWidget with ArticleBodyUtils {
  final NavigationCarouselStore store;
  const NavigationCarousel({
    super.key,
    required this.store,
  });
  // add the swipe detection and those components later

  @override
  Widget build(BuildContext context) {
    final containerSize = useFullScreenSize().height * .2;
    final size = useScaledSize(
      baseValue: .07,
      screenSize: useFullScreenSize(),
      bumpPerHundredth: 0.0001,
    );

    useEffect(() {
      store.constructor();
      return null;
    }, []);
    return Observer(builder: (context) {
      return CustomAnimationBuilder(
          control: store.beachWaves.currentControl,
          duration: store.beachWaves.currentMovie.duration,
          tween: store.beachWaves.currentMovie,
          builder: (context, value, child) {
            return Swipe(
              store: store.swipe,
              child: Stack(
                children: [
                  FullScreen(
                    child: CustomPaint(
                      painter: StepwiseBeachWavesPainter(
                        scrollPercentage: interpolate(
                          currentValue: store.carouselPosition,
                          targetValue: 1,
                          maxOutput: 0,
                          minOutput: 1,
                        ),
                        transitionValue: store.carouselPosition, // 0.0 to 1.0
                        gradientConfigs: [
                          ColorAndStop.toGradientConfig(
                              WaterColorsAndStops.deeperBlue),
                          ColorAndStop.toGradientConfig(
                              WaterColorsAndStops.onShoreWater),
                          ColorAndStop.toGradientConfig(
                              WaterColorsAndStops.sky),
                        ],
                        waterValue: value.get('waterMovement'),
                      ),
                    ),
                  ),
                  Tint(
                    store: store.tint,
                  ),
                  AnimatedOpacity(
                    opacity: useWidgetOpacity(store.swipeUpBannerVisibility),
                    duration: Seconds.get(1),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 10,
                            ),
                            child: ActionSlider.standard(
                              toggleColor: Colors.black.withOpacity(.5),
                              backgroundColor: Colors.black.withOpacity(0),
                              icon: Image.asset(
                                'assets/qr_code_icon.png',
                                // width: iconWidth,
                                // height: iconWidth,
                              ),
                              customBackgroundBuilder: (p0, p1, p2) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    // color: Colors.black,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Jost(
                                      'Start Session',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                              boxShadow: [],
                              action: (controller) {
                                if (!store.swipeUpBannerVisibility) return;
                                Modular.to.navigate(
                                  HomeConstants.quickActionsRouter,
                                  arguments: {
                                    HomeConstants.QUICK_ACTIONS_ROUTE:
                                        SessionStarterConstants.sessionStarter,
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: ActionSlider.standard(
                              toggleColor: Colors.black.withOpacity(.5),
                              backgroundColor: Colors.black.withOpacity(0),
                              icon: Image.asset(
                                'assets/camera_icon.png',
                                // width: iconWidth,
                                // height: iconWidth,
                              ),
                              customBackgroundBuilder: (p0, p1, p2) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    // color: Colors.black,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Jost(
                                      'Join Session',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                              boxShadow: [],
                              action: (controller) {
                                if (!store.swipeUpBannerVisibility) return;
                                Modular.to.navigate(
                                  HomeConstants.quickActionsRouter,
                                  arguments: {
                                    HomeConstants.QUICK_ACTIONS_ROUTE:
                                        SessionJoinerConstants.sessionJoiner,
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: useWidgetOpacity(store.swipeDownBannerVisibility),
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
                    opacity: useWidgetOpacity(store.swipeUpBannerVisibility),
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
                  AnimatedOpacity(
                    opacity: useWidgetOpacity(store.swipeUpBannerVisibility),
                    duration: Seconds.get(1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: containerSize * .29,
                            scrollPhysics: store.swipeUpBannerVisibility
                                ? null
                                : const NeverScrollableScrollPhysics(),
                            aspectRatio: 1,
                            viewportFraction: .28,
                            initialPage: 1,
                            enableInfiniteScroll: false,
                            onScrolled: (value) {
                              store.setCarouselPosition(value ?? 0.0);
                            },
                          ),
                          items: List.generate(store.carouselItems.length,
                              (index) {
                            return Opacity(
                              opacity: interpolate(
                                currentValue: store.carouselPosition,
                                targetValue: index.toDouble(),
                                maxOutput: 1,
                                minOutput: 0.5,
                              ),
                              child: Container(
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
                                  child: Jost(
                                    store.carouselItems[index],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
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
                            length: store.carouselItems.length,
                            currentPosition: store.carouselPosition,
                            containerSize: containerSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}

class StepwiseBeachWavesPainter extends CustomPainter {
  final double transitionValue;
  final List<GradientConfig> gradientConfigs;
  final double waterValue;
  final double scrollPercentage;
  final int waveCount;
  final double waveAmplitude;
  final bool shouldPaintAdditional;
  final void Function(Canvas canvas, Size size)? additionalPainter;

  StepwiseBeachWavesPainter({
    required this.waterValue,
    required this.transitionValue,
    required this.gradientConfigs,
    required this.scrollPercentage,
    this.waveCount = 3,
    this.waveAmplitude = 20.0,
    this.shouldPaintAdditional = false,
    this.additionalPainter,
  }) : assert(gradientConfigs.length >= 2,
            'At least two gradient configurations are required');

  GradientConfig _interpolateGradientConfigs() {
    final double normalizedTransition =
        transitionValue.clamp(0.0, gradientConfigs.length - 1.0);

    final int currentIndex = normalizedTransition.floor();
    final int nextIndex =
        (currentIndex + 1).clamp(0, gradientConfigs.length - 1);

    final double localTransition = normalizedTransition - currentIndex;

    final List<Color> interpolatedColors = List.generate(
        gradientConfigs[currentIndex].colors.length,
        (i) => Color.lerp(gradientConfigs[currentIndex].colors[i],
            gradientConfigs[nextIndex].colors[i], localTransition)!);

    final List<double> interpolatedStops = List.generate(
        gradientConfigs[currentIndex].stops.length,
        (i) => lerpDouble(gradientConfigs[currentIndex].stops[i],
            gradientConfigs[nextIndex].stops[i], localTransition));

    return GradientConfig(colors: interpolatedColors, stops: interpolatedStops);
  }

  double lerpDouble(double start, double end, double t) {
    return start + (end - start) * t;
  }

  paintSand(Canvas canvas, Size size, SandTypes sandType) {
    final sandGrandient = Paint();
    List<Color> colors = [];
    List<double> stops = [];
    switch (sandType) {
      case SandTypes.home:
        colors = const [
          Color(0xFFD2B48C),
          Color(0xFF8B5E3C),
        ];
        stops = [0, .3];
      case SandTypes.collaboration:
        colors = const [
          Color(0xFFFFE6C4),
          Color(0xFFFFBC78),
        ];
        stops = [0, .2];
    }
    sandGrandient.shader = LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    // break;
    canvas.drawRect(Offset.zero & size, sandGrandient);
  }

  paintWater(Canvas canvas, Size size) {
    const waveCount = 3;
    const waveAmplitude = 20.0;

    final interpolatedConfig = _interpolateGradientConfigs();
    final waveGradient = LinearGradient(
      colors: interpolatedConfig.colors,
      stops: interpolatedConfig.stops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final waterPaint = Paint()
      ..shader = waveGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final phase = waterValue + (scrollPercentage * 100);

    for (int i = 0; i < waveCount; i++) {
      final waveOffset = size.height / (waveCount + 1) * (i + 1);
      final yOffset = phase * 3;
      final path = Path()
        ..moveTo(0, waveOffset + yOffset)
        ..cubicTo(
          size.width / 3,
          waveOffset + yOffset - waveAmplitude.half(),
          2 * size.width / 3,
          waveOffset + yOffset + waveAmplitude.half(),
          size.width,
          waveOffset + yOffset,
        )
        ..lineTo(size.width, 0)
        ..lineTo(0, 0)
        ..close();
      canvas.drawPath(path, waterPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (shouldPaintAdditional && additionalPainter != null) {
      additionalPainter!(canvas, size);
    }
    paintSand(canvas, size, SandTypes.home);

    paintWater(canvas, size);
  }

  @override
  bool shouldRepaint(StepwiseBeachWavesPainter oldDelegate) {
    return oldDelegate.transitionValue != transitionValue ||
        oldDelegate.gradientConfigs != gradientConfigs ||
        oldDelegate.waterValue != waterValue;
  }
}
