import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/use_square_size.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class ModalBackdrop extends HookWidget with ArticleBodyUtils {
  final CompanyPresetsEntity entity;
  final int activeIndex;
  final double currentPosition;
  final SessionTags currentTag;
  final PowerupInfo powerUpInfo;
  final List<SessionTags> articleSectionsTags;
  final List<ArticleOptions> options;
  final List<ArticleSection> articleSections;
  final String currentInstructionsHeader;
  final List<String> currentInstruction;
  final List<String> currentJustification;

  final Function(double value) onScrolled;
  final ToggleCallback onToggle;

  const ModalBackdrop({
    super.key,
    required this.entity,
    required this.options,
    required this.activeIndex,
    required this.currentPosition,
    required this.currentTag,
    required this.articleSectionsTags,
    required this.articleSections,
    required this.currentInstructionsHeader,
    required this.currentInstruction,
    required this.currentJustification,
    required this.onScrolled,
    required this.powerUpInfo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = useSquareSize(relativeLength: .4).height;
    return DraggableScrollableSheet(
      maxChildSize: .91,
      initialChildSize: .9,
      minChildSize: .7,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ...ArticleHeader.get(
              title: entity.articles[activeIndex].title,
              tagline: entity.articles[activeIndex].tagline,
              uniqueFeature: entity.articles[activeIndex].uniqueFeature,
            ),
            Options(
              articleSections: articleSectionsTags,
              options: options,
              onToggle: onToggle,
            ),
            Column(
              children: [
                ArticleCarouselSlider(
                  onScrolled: onScrolled,
                  articleSections: articleSections,
                  containerSize: containerSize,
                  currentPosition: currentPosition,
                ),
                ArticleContent(
                  currentTag: currentTag,
                  articleSections: articleSectionsTags,
                  currentInstructionsHeader: currentInstructionsHeader,
                  currentInstructionsBody: currentInstruction,
                  currentJustifications: currentJustification,
                  opacity: contentLerp(currentPosition),
                  currentPosition: currentPosition,
                  powerUpInformation: powerUpInfo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
