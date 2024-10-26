import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class PowerupExplanation extends HookWidget {
  final PowerupInfo info;
  final List<SessionTags> articleSections;

  const PowerupExplanation({
    super.key,
    required this.info,
    required this.articleSections,
  });
  @override
  Widget build(BuildContext context) {
    return info.powerup != Powerups.none
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
                bottom: 20.0,
              ),
              child: Chivo(
                'Power Up: **${info.name}**',
                fontSize: 27,
              ),
            ),
            Image.asset(
              info.imagePath,
              width: 60,
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              child: TagLine(
                info.tagline,
                useExpandedPadding: false,
                shouldGiveMoreSpaceToTheRight: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 6.0,
                bottom: 10.0,
              ),
              child: Chivo(
                'What it does:',
                fontSize: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichJostList(
                contentList: [info.description],
                isOrdered: false,
                horizontalPadding: 80,
              ),
            ),
            DemoPhones(
              articleSections: articleSections,
              demoType: Right(info.powerup),
            ),
          ])
        : Container();
  }
}
