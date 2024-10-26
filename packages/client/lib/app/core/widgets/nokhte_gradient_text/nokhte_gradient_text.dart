import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'nokhte_gradient_text_store.dart';
export 'nokhte_gradient_text_store.dart';

class NokhteGradientText extends StatelessWidget {
  final NokhteGradientTextStore store;
  final String content;
  final List<Color> gradient;
  final EdgeInsets padding;
  final double textScaleFactor;
  const NokhteGradientText({
    super.key,
    required this.store,
    required this.content,
    required this.gradient,
    this.padding = EdgeInsets.zero,
    this.textScaleFactor = 1.9,
  });

  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => GestureDetector(
          onTap: () {
            store.onTap();
          },
          child: AnimatedOpacity(
            opacity: useWidgetOpacity(store.showWidget),
            duration: Seconds.get(1),
            child: Center(
              child: Padding(
                padding: padding,
                child: GradientText(
                  content,
                  textScaleFactor: textScaleFactor,
                  colors: gradient,
                  style: GoogleFonts.jost(),
                ),
              ),
            ),
          ),
        ),
      );
}
