// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'mobx/context_header_store.dart';
export 'mobx/context_header_store.dart';

class ContextHeader extends HookWidget {
  final ContextHeaderStore store;
  final double scrollPercentage;

  const ContextHeader({
    super.key,
    required this.store,
    required this.scrollPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () => store.onTap(),
        child: AnimatedOpacity(
          opacity: useWidgetOpacity(store.showWidget),
          duration: Seconds.get(1),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: useScaledSize(
                baseValue: .55,
                bumpPerHundredth: -0.0000,
                screenSize: screenSize,
              ),
            ),
            child: Center(
              child: Container(
                height: useScaledSize(
                  baseValue: .094,
                  screenSize: screenSize,
                  bumpPerHundredth: .0004,
                ),
                width: screenSize.width * .48,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16)),
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Jost(
                      'group: ${store.groupName}',
                      fontSize: 15,
                      useEllipsis: true,
                      // fontWeight: FontWeight.w300,
                    ),
                    Jost(
                      'queue: ${store.queueName}',
                      fontSize: 15,
                      useEllipsis: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
