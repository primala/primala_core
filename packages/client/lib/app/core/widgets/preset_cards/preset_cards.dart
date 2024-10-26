import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'movies/movies.dart';
export 'icons/icons.dart';
export 'mixins/mixins.dart';
export 'types/types.dart';
export 'mobx/preset_cards_store.dart';

class PresetsCards extends HookWidget {
  final PresetCardsStore store;

  const PresetsCards({
    super.key,
    required this.store,
  });

  Widget buildText(Movie value, String text, double height) {
    return text.isEmpty
        ? Container()
        : Padding(
            padding: EdgeInsets.only(top: height * .02, left: height * .03),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  value.get('c1'),
                  value.get('c2'),
                  value.get('c3'),
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                text,
                style: GoogleFonts.jost(
                  fontSize: height * .03,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          );
  }

  Widget buildTile(String text, double height, double width, Size screenSize) {
    final i = store.names.indexOf(text);
    if (text.isEmpty) {
      return SizedBox(height: height * 0.2);
    } else {
      return Observer(builder: (context) {
        return NokhteCustomAnimationBuilder(
          tween: store.movies[i],
          duration: store.movies[i].duration,
          control: store.controls[i],
          onCompleted: () => store.onAnimationCompleted(i),
          builder: (context, value, child) {
            if (i == store.currentHeldIndex) {
              store.setSelectedPresetColors(
                [value.get('c1'), value.get('c2'), value.get('c3')],
              );
            }
            return GestureDetector(
              onTap: () => store.onTap(i),
              onLongPressStart: (details) {
                store.setCurrentHeldIndex(i);
              },
              child: Opacity(
                opacity: value.get('c1').opacity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Colors.white.withOpacity(.2),
                    ),
                    // decoration: buildSquareDecoration(value, text.isEmpty),
                    height: useScaledSize(
                      baseValue: .15,
                      screenSize: screenSize,
                      bumpPerHundredth: .0006,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText(value, text, height),
                            const Padding(
                              padding: EdgeInsets.only(top: 2, right: 8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: TagLine(
                            store.taglines[i],
                            useExpandedPadding: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = useFullScreenSize();
    final width = size.width;
    final height = size.height;

    return Observer(
      builder: (context) => AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.12),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.names.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: buildTile(store.names[i], height, width, size),
            ),
          ),
        ),
      ),
    );
  }
}
