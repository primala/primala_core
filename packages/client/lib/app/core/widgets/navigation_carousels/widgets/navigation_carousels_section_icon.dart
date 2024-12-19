import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class NavigationCarouselsSectionIcon extends HookWidget {
  final Function(NavigationCarouselsSectionTypes type) onTap;
  final NavigationCarouselsSectionTypes type;
  final NavigationCarouselsSectionDetails details;
  // final String assetPath;

  final bool isSelected;

  NavigationCarouselsSectionIcon({
    super.key,
    required this.type,
    required this.onTap,
    required this.isSelected,
  }) : details = NavigationCarouselsSectionDetails(type);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(type);
      },
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.5,
        duration: Seconds.get(0, milli: 500),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: type == NavigationCarouselsSectionTypes.queueIcon
                      ? 1.5
                      : 0,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                details.assetPath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 10),
            // Chivo(
            //   details.sectionHeader,
            //   fontSize: 16,
            //   fontColor: Colors.white,
            // )
          ],
        ),
      ),
    );
  }
}
