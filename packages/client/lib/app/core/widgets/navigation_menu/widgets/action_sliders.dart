import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GeneralizedActionSlider extends HookWidget {
  final String assetPath;
  final String sliderText;
  final Function onSlideComplete;
  final bool showWidget;

  const GeneralizedActionSlider({
    super.key,
    required this.assetPath,
    required this.sliderText,
    required this.onSlideComplete,
    required this.showWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
      child: ActionSlider.standard(
        // enabled: showWidget,
        toggleColor: Colors.black.withOpacity(.5),
        backgroundColor: Colors.black.withOpacity(0),
        icon: Image.asset(assetPath),
        customBackgroundBuilder: (p0, p1, p2) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                sliderText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        boxShadow: const [],
        action: (controller) {
          if (!showWidget) return;
          onSlideComplete();
        },
      ),
    );
  }
}
