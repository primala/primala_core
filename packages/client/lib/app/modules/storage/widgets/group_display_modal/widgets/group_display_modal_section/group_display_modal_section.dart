import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'types.dart';

class GroupDisplayModalSection extends HookWidget {
  final Function(GroupDisplayModalSectionType type) onTap;
  final GroupDisplayModalSectionType type;
  final GroupDisplayModalDetails details;
  final bool isSelected;

  GroupDisplayModalSection({
    super.key,
    required this.type,
    required this.onTap,
    required this.isSelected,
  }) : details = GroupDisplayModalDetails(type);

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
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                details.assetPath,
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(height: 10),
            Chivo(
              details.sectionHeader,
              fontSize: 16,
              fontColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
