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
  final EdgeInsets padding;
  final Widget prefixWidget;

  const GenericMenuItem({
    super.key,
    required this.onTap,
    required this.title,
    this.subtitle = '',
    this.padding = const EdgeInsets.only(left: 16, bottom: 4, top: 4),
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
    required this.showChevron,
    this.prefixWidget = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
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
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixWidget,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Jost(
                    title,
                    fontSize: 16.0,
                    fontColor: textColor,
                  ),
                  subtitle.isNotEmpty
                      ? Jost(
                          subtitle,
                          fontSize: 12,
                          fontColor: Colors.black.withOpacity(.6),
                        )
                      : Container(),
                ],
              ),
              Spacer(),
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
