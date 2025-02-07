import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class HeaderRow extends HookWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final bool includeDivider;
  final String title;
  final Function? onChevronTapped;
  final Color chevronColor;

  const HeaderRow({
    this.title = '',
    super.key,
    this.onChevronTapped,
    this.children = const [],
    this.includeDivider = false,
    this.chevronColor = Colors.black,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = useFullScreenSize().height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * .1),
      child: Column(
        children: [
          MultiHitStack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmartHeader(
                    content: title,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: onChevronTapped == null
                    ? children
                    : [
                        LeftChevron(
                          onTap: onChevronTapped,
                          color: chevronColor,
                        ),
                      ],
              ),
            ],
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
