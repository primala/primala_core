import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/types/types.dart';

// collaborators_carousel.dart
class CollaboratorsCarousel extends HookWidget {
  final List<UserEntity> collaborators;
  final Function(UserEntity)? onTap;
  final double height;
  final double viewportFraction;
  final double avatarSize;
  final double fontSize;
  final bool showFullName;
  final Function(UserEntity)? onDeselected;

  const CollaboratorsCarousel({
    super.key,
    required this.collaborators,
    this.onTap,
    this.height = 100,
    this.viewportFraction = 0.2,
    this.avatarSize = 60,
    this.fontSize = 12,
    this.showFullName = true,
    this.onDeselected,
  });

  @override
  Widget build(BuildContext context) {
    if (collaborators.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Jost(
            "No collaborators",
            fontSize: fontSize,
            shouldCenter: true,
            softWrap: true,
          ),
        ),
      );
    }
    return CarouselSlider(
      items: List.generate(collaborators.length, (index) {
        final user = collaborators[index];
        return GestureDetector(
          onTap: () => onTap?.call(user),
          child: Padding(
            padding: EdgeInsets.only(top: onDeselected == null ? 0 : 8.0),
            child: Column(
              children: [
                UserAvatar(
                  fullName: user.fullName,
                  gradient: user.profileGradient,
                  size: avatarSize,
                  fontSize: avatarSize / 3,
                  onXTap: onDeselected == null
                      ? null
                      : () => onDeselected?.call(user),
                ),
                if (showFullName)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Jost(
                      user.fullName,
                      fontSize: fontSize,
                      shouldCenter: true,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
      options: CarouselOptions(
        padEnds: false,
        pageSnapping: false,
        viewportFraction: viewportFraction,
        height: height,
        enableInfiniteScroll: false,
      ),
    );
  }
}
