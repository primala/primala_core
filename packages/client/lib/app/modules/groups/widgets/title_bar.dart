import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class TitleBar extends HookWidget {
  final String rightTextLabel;
  final String centerTextLabel;
  final Function onCancelTapped;
  final Function onConfirmTapped;

  const TitleBar({
    super.key,
    required this.rightTextLabel,
    required this.centerTextLabel,
    required this.onCancelTapped,
    required this.onConfirmTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () => onCancelTapped(),
            child: const Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Jost(
                'Cancel',
                fontColor: NokhteColors.blue,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Jost(
              centerTextLabel,
              fontColor: NokhteColors.black,
              fontSize: 25,
            ),
          ),
          GestureDetector(
            onTap: () async => await onConfirmTapped(),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Jost(
                rightTextLabel,
                fontColor: NokhteColors.blue,
                fontSize: 18,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
