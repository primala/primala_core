import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class ArticleCarouselSlider extends StatelessWidget with ArticleBodyUtils {
  final Function(double currentPosition) onScrolled;
  final List<ArticleSection> articleSections;
  final double containerSize;
  final double currentPosition;
  const ArticleCarouselSlider({
    super.key,
    required this.onScrolled,
    required this.articleSections,
    required this.containerSize,
    required this.currentPosition,
  });

  Widget mapTagToIcon(
      SessionTags tag, double targetValue, double containerSize) {
    if (tag == SessionTags.holdToSpeak) {
      return buildIcon(
        targetValue: targetValue,
        containerSize: containerSize,
        shouldAnimate: true,
        iconBuilder: (context, size, opacity, animate) => TalkingIcons(
          isHoldToTalk: true,
          containerSize: size,
          opacity: opacity,
          shouldAnimate: true,
        ),
      );
    } else if (tag == SessionTags.tapToSpeak) {
      return buildIcon(
        targetValue: targetValue,
        containerSize: containerSize,
        shouldAnimate: true,
        iconBuilder: (context, size, opacity, animate) => TalkingIcons(
          isHoldToTalk: false,
          containerSize: size,
          opacity: opacity,
          shouldAnimate: true,
        ),
      );
    } else if (tag == SessionTags.strictSeating) {
      return buildIcon(
        targetValue: targetValue,
        containerSize: containerSize,
        shouldAnimate: true,
        iconBuilder: (context, size, opacity, animate) => StrictSeatingIcon(
          containerSize: size,
          opacity: opacity,
          shouldAnimate: true,
        ),
      );
    } else if (tag == SessionTags.flexibleSeating) {
      return buildIcon(
        targetValue: targetValue,
        containerSize: containerSize,
        shouldAnimate: true,
        iconBuilder: (context, size, opacity, animate) => FlexibleSeatingIcon(
          containerSize: size,
          opacity: opacity,
          shouldAnimate: true,
        ),
      );
    } else if (tag == SessionTags.monoFocalNotes ||
        tag == SessionTags.multiFocalNotes ||
        tag == SessionTags.deactivatedNotes) {
      // MonoFocalNotes and default case
      return buildIcon(
        targetValue: targetValue,
        containerSize: containerSize,
        shouldAnimate: true,
        iconBuilder: (context, size, opacity, animate) => NotesIcon(
          containerSize: size,
          opacity: opacity,
          shouldAnimate: true,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildIcon({
    required double targetValue,
    required Widget Function(BuildContext, double, double, bool) iconBuilder,
    required double containerSize,
    required bool shouldAnimate,
  }) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: interpolate(
                currentValue: currentPosition,
                targetValue: targetValue,
                minOutput: 30,
                maxOutput: 20,
              ),
            ),
            child: iconBuilder(
              context,
              interpolate(
                currentValue: currentPosition,
                targetValue: targetValue,
                maxOutput: containerSize * 1.5,
                minOutput: containerSize * 1,
              ),
              interpolate(
                currentValue: currentPosition,
                targetValue: targetValue,
                minOutput: 0.5,
                maxOutput: 1.0,
              ),
              shouldAnimate,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 23.0),
          child: Container(
            height: 1.5, // Thin line
            color: Colors.white.withOpacity(0.45),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: containerSize * .69,
            aspectRatio: 1,
            viewportFraction: .28,
            enableInfiniteScroll: false,
            onScrolled: (value) {
              onScrolled(value ?? 0);
            },
          ),
          items: List.generate(articleSections.length, (index) {
            return mapTagToIcon(
              articleSections[index].tag,
              index.toDouble(),
              containerSize,
            );
          }),
        ),
        CarouselPlacementIndicator(
          length: articleSections.length,
          currentPosition: currentPosition,
          containerSize: containerSize,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Container(
            height: 1.5, // Thin line
            color: Colors.white.withOpacity(0.45),
          ),
        ),
      ],
    );
  }
}
