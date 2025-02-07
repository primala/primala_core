import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class GenericButton extends HookWidget {
  final bool isEnabled;
  final Function onPressed;
  final String label;
  final bool useFixedSize;
  final double borderRadius;

  final Color color;

  const GenericButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    required this.label,
    this.color = Colors.black,
    this.useFixedSize = false,
    this.borderRadius = 7.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    final width = screenSize.width;

    // Determine text color based on background color's brightness
    Color determineTextColor(Color backgroundColor) {
      return backgroundColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    }

    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: screenSize.height * .08,
              left: width * .15,
              right: width * .15,
            ),
            child: ElevatedButton(
              onPressed: isEnabled ? () => onPressed() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: color.withOpacity(.5),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: useFixedSize ? 0 : 35,
                ),
                fixedSize: useFixedSize ? Size(width * 0.7, 50) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Jost(
                label,
                fontColor: determineTextColor(color),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    });
  }
}
