import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class GenericMenuItem extends HookWidget {
  final Function onTap;
  final String title;
  final String subtitle;
  final Color textColor;
  final bool showChevron;
  final Color borderColor;

  const GenericMenuItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
    required this.showChevron,
  });

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
          bottom: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 4.0,
            top: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Jost(
                    title,
                    fontSize: 16.0,
                    fontColor: textColor,
                  ),
                  Jost(
                    subtitle,
                    fontSize: 12,
                    fontColor: Colors.black.withOpacity(.6),
                  ),
                ],
              ),
              if (showChevron)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 20,
                    // weight: 100,
                    color: Colors.black,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
