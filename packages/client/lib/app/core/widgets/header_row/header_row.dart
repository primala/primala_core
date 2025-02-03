import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';

class HeaderRow extends HookWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final bool includeDivider;

  const HeaderRow({
    super.key,
    required this.children,
    this.includeDivider = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = useFullScreenSize().height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * .1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
          if (includeDivider)
            const Divider(
              color: NokhteColors.black,
              thickness: 1,
              height: 36,
            ),
        ],
      ),
    );
  }
}
