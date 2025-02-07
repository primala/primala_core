// ignore_for_file: unused_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:simple_animations/simple_animations.dart';
export 'canvas/checkmark_painter.dart';
export 'movies/movies.dart';
export 'mobx/let_em_cook_store.dart';
export 'constants/constants.dart';

class LetEmCook extends HookWidget {
  final LetEmCookStore store;
  const LetEmCook(
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = useScaledSize(
        baseValue: 0.08,
        screenSize: useFullScreenSize(),
        bumpPerHundredth: 0.0005);
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: GestureDetector(
          onTap: store.buttonVisibility ? () => store.onTap() : null,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: useWidgetOpacity(store.buttonVisibility),
                duration: Seconds.get(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: containerSize,
                        width: containerSize,
                        child: Image.asset(
                          'assets/power_up/cook_button.png',
                          width: containerSize,
                          height: containerSize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Jost(
                        'Let ${store.currentCook} cook',
                        fontSize: containerSize * 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              CustomAnimationBuilder(
                  tween: CheckmarkMovies.movie,
                  duration: CheckmarkMovies.movie.duration,
                  control: store.control,
                  onCompleted: () {
                    store.setSentAnimationVisibility(false);
                    // store.onCompleted();
                  },
                  builder: (context, value, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: containerSize,
                            width: containerSize,
                            child: CustomPaint(
                              painter: CheckmarkPainter(
                                l1Progress: value.get('l1'),
                                l2Progress: value.get('l2'),
                                opacity: value.get('opacity'),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 3),
                        //   child: NokhteGradientText(
                        //     store: NokhteGradientTextStore(),
                        //     content: 'Sent',
                        //     gradient: LetEmCookConstants.greenGrad(
                        //         value.get('opacity')),
                        //   ),
                        // ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
