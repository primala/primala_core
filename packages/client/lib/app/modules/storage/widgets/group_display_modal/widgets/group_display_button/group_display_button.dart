import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final Function onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.5,
      duration: Seconds.get(1),
      child: GestureDetector(
        onTap: isEnabled ? onPressed() : null,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Center(
              child: Jost(
                text,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupDisplayButtons extends HookWidget {
  final Function onStartPressed;
  final Function onJoinPressed;
  final bool startIsEnabled;
  final bool joinIsEnabled;

  const GroupDisplayButtons({
    super.key,
    required this.onStartPressed,
    required this.onJoinPressed,
    required this.startIsEnabled,
    required this.joinIsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(width: 100),
        CustomButton(
          text: 'Start',
          isEnabled: startIsEnabled,
          onPressed: onStartPressed,
        ),
        CustomButton(
          text: 'Join',
          isEnabled: joinIsEnabled,
          onPressed: onJoinPressed,
        ),
      ],
    );
  }
}
