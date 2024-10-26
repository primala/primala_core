import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class ArticleContent extends StatelessWidget {
  final String currentInstructionsHeader;
  final List<String> currentInstructionsBody;
  final List<String> currentJustifications;
  final List<SessionTags> articleSections;
  final SessionTags currentTag;

  final PowerupInfo powerUpInformation;
  final double opacity;
  final double currentPosition;

  const ArticleContent({
    super.key,
    required this.currentInstructionsHeader,
    required this.currentInstructionsBody,
    required this.currentJustifications,
    required this.currentTag,
    required this.opacity,
    required this.powerUpInformation,
    required this.articleSections,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Chivo(
              currentInstructionsHeader,
              fontSize: 27,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: RichJostList(
              contentList: currentInstructionsBody,
              isOrdered: true,
            ),
          ),
          DemoPhones(
            articleSections: articleSections,
            demoType: Left(currentTag),
          ),
          PowerupExplanation(
            info: powerUpInformation,
            articleSections: articleSections,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Chivo(
              currentJustifications.isNotEmpty ? 'Reasons:' : '',
              fontSize: 27,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: RichJostList(
              contentList: currentJustifications,
              isOrdered: false,
            ),
          )
        ],
      ),
    );
  }
}
