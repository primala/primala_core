import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class SeatingDemos extends HookWidget {
  final List<SessionTags> allTheTags;
  const SeatingDemos(
    this.allTheTags, {
    super.key,
  });

  String _getImagePath(List<SessionTags> allTheTags) {
    if (allTheTags.contains(SessionTags.flexibleSeating)) {
      return 'assets/flexible_seating.png';
    } else if (allTheTags.contains(SessionTags.strictSeating)) {
      return 'assets/strict_seating.png';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;

    String imagePath = _getImagePath(allTheTags);
    return imagePath.isNotEmpty
        ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Chivo(
                  'Example',
                  fontSize: 27,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  imagePath,
                  width: width * 0.8,
                  height: width * 0.8,
                ),
              ),
            ],
          )
        : Container();
  }
}
