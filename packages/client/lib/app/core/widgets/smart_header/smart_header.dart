// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class SmartHeader extends HookWidget {
  final bool showWidget;
  final String content;
  const SmartHeader({
    super.key,
    required this.showWidget,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Observer(
      builder: (context) => FullScreen(
        child: AnimatedOpacity(
          opacity: useWidgetOpacity(showWidget),
          duration: Seconds.get(0, milli: 500),
          child: Padding(
            padding: EdgeInsets.only(bottom: screenSize.height * .8),
            child: Center(
              child: Jost(
                content,
                fontSize: 40,
                shouldCenter: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
