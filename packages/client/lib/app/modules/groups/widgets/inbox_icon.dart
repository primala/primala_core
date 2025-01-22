import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class InboxIcon extends HookWidget {
  final bool showWidget;
  final Function onTap;
  final int badgeCount;

  const InboxIcon({
    super.key,
    required this.showWidget,
    required this.onTap,
    required this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return AnimatedOpacity(
      opacity: useWidgetOpacity(showWidget),
      duration: Seconds.get(0, milli: 500),
      child: Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenSize.width * .10,
          ),
          child: MultiHitStack(
            clipBehavior: Clip.none,
            children: [
              if (badgeCount > 0)
                Positioned(
                  right: -15,
                  top: badgeCount > 9 ? -9 : -7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Jost(
                        badgeCount > 9 ? "9+" : badgeCount.toString(),
                        // badgeCount.toString(),
                        fontSize: 12,
                        fontColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Image.asset(
                  'assets/groups/envelope_icon.png',
                  height: 45,
                  width: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
