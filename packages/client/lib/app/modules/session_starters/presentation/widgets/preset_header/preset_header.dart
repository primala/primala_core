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
export 'mobx/preset_header_store.dart';

class PresetHeader extends HookWidget {
  final PresetHeaderStore store;
  final double scrollPercentage;

  const PresetHeader({
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
          opacity: useWidgetOpacity(store.presetIcons.showWidget),
          duration: Seconds.get(1),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: useScaledSize(
                baseValue: .85,
                bumpPerHundredth: -0.0000,
                screenSize: screenSize,
              ),
            ),
            child: Center(
              child: Container(
                height: useScaledSize(
                  baseValue: .104,
                  screenSize: screenSize,
                  bumpPerHundredth: .0004,
                ),
                width: screenSize.width * .48,
                decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00E9E9),
                          // Color(0xFF81B4FF),
                          Color(0xFF81B4FF),
                        ],
                      ),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16)),
                // color: Colors.red,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: useScaledSize(
                          baseValue: .003,
                          bumpPerHundredth: 0.0002,
                          screenSize: screenSize,
                        ),
                        bottom: useScaledSize(
                          baseValue: .003,
                          bumpPerHundredth: 0.0000,
                          screenSize: screenSize,
                        ),
                      ),
                      child: GradientText(
                        store.presetName,
                        colors: const [
                          Color(0xFF109EEE),
                          Color(0xFF6BAFFF),
                        ],
                        style: GoogleFonts.jost(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    PresetIcons(
                      store: store.presetIcons,
                    ),
                    //h
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
