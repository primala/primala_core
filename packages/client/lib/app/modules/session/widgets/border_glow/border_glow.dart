import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:ui';
import 'border_glow.dart';
export 'movies/movies.dart';
export 'border_glow.dart';
export 'border_glow_store.dart';
export 'constants/constants.dart';

class BorderGlow extends HookWidget {
  final BorderGlowStore store;
  const BorderGlow({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => AnimatedOpacity(
              opacity: useWidgetOpacity(store.showWidget),
              duration: Seconds.get(1),
              child: CustomAnimationBuilder(
                tween: store.movie,
                control: store.control,
                duration: store.movie.duration,
                builder: (context, value, child) {
                  store.setAnimationValues(
                    color: value.get('color'),
                    width: value.get('width'),
                  );
                  return ClipPath(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: value.get('color'),
                          width: value.get('width'),
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 40,
                          sigmaY: 40,
                        ),
                        child: Container(),
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
