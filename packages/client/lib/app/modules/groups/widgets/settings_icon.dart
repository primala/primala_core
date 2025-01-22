import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';

class SettingsIcon extends HookWidget {
  final bool showWidget;
  final Function onTap;

  const SettingsIcon({
    super.key,
    required this.showWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return AnimatedOpacity(
      opacity: useWidgetOpacity(showWidget),
      duration: Seconds.get(0, milli: 500),
      child: Container(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(
            right: screenSize.width * .10,
            top: useScaledSize(
              baseValue: .081,
              screenSize: screenSize,
              bumpPerHundredth: -.0003,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Image.asset(
              'assets/groups/settings_icon.png',
              height: 40,
              width: 40,
            ),
          ),
        ),
      ),
    );
  }
}
