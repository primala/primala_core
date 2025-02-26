// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/home/home.dart';

class CarouselScaffold extends HookWidget with OpacityUtils {
  final List<Widget> children;
  final bool showWidgets;
  final bool showCarousel;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Function dispose;
  final int initialPosition;
  final bool isScrollable;
  final Widget floatingActionButton;

  const CarouselScaffold({
    super.key,
    required this.dispose,
    required this.children,
    required this.initialPosition,
    this.isScrollable = false,
    this.showCarousel = true,
    this.showWidgets = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.floatingActionButton = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    final currentPosition = useState(initialPosition.toDouble());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: NokhteColors.eggshell,
      floatingActionButton: AnimatedOpacity(
        opacity: useWidgetOpacity(showWidgets),
        duration: const Duration(milliseconds: 500),
        child: Opacity(
          opacity: interpolate(
            currentValue: currentPosition.value,
            targetValue: initialPosition.toDouble(),
            minOutput: 0.0,
            maxOutput: 1.0,
          ),
          child: floatingActionButton,
        ),
      ),
      body: MultiHitStack(
        children: [
          AnimatedOpacity(
            opacity: useWidgetOpacity(showWidgets),
            duration: const Duration(milliseconds: 500),
            child: Opacity(
                opacity: interpolate(
                  currentValue: currentPosition.value,
                  targetValue: initialPosition.toDouble(),
                  minOutput: 0.0,
                  maxOutput: 1.0,
                ),
                child: isScrollable
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: mainAxisAlignment,
                          crossAxisAlignment: crossAxisAlignment,
                          children: [
                            ...children,
                            // const Spacer(),
                            NavCarousel(
                              currentPosition: currentPosition.value,
                              onPositionChanged: (value) =>
                                  currentPosition.value = value,
                              carouselItems: const ['', '', ''],
                              callbacks: [() {}, () {}, () {}],
                              initialPosition: initialPosition,
                              isEnabled: false,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: mainAxisAlignment,
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          ...children,
                          const Spacer(),
                          NavCarousel(
                            currentPosition: currentPosition.value,
                            onPositionChanged: (value) =>
                                currentPosition.value = value,
                            carouselItems: const ['', '', ''],
                            callbacks: [() {}, () {}, () {}],
                            initialPosition: initialPosition,
                            isEnabled: false,
                          ),
                        ],
                      )),
          ),
          AnimatedOpacity(
            opacity: useWidgetOpacity(showCarousel),
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                const Spacer(),
                NavCarousel(
                  currentPosition: currentPosition.value,
                  onPositionChanged: (value) => currentPosition.value = value,
                  carouselItems: const ['info', 'home', 'docs'],
                  callbacks: [
                    () async {
                      await dispose();
                      Modular.to.navigate(HomeConstants.information);
                    },
                    () async {
                      await dispose();
                      Modular.to.navigate(HomeConstants.homeScreen);
                    },
                    () async {
                      await dispose();
                      Modular.to.navigate(DocsConstants.docsHub);
                    }
                  ],
                  initialPosition: initialPosition,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
