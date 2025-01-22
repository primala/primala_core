import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class AuthButton extends HookWidget {
  final bool isEnabled;
  final bool showWidget;
  final Function onPressed;
  final String label;
  const AuthButton({
    super.key,
    required this.isEnabled,
    required this.showWidget,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    final width = screenSize.width;
    return Observer(builder: (context) {
      return AnimatedOpacity(
          opacity: useWidgetOpacity(showWidget),
          duration: Seconds.get(0, milli: 500),
          child: Column(
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
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white.withOpacity(.5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    fixedSize: Size(width * 0.7, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Jost(
                    label,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    // style: TextStyle(
                    //   color: Colors.black,
                    //   fontWeight: FontWeight.w300,
                    // ),
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
