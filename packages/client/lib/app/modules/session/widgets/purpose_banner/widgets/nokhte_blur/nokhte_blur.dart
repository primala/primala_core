import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:simple_animations/simple_animations.dart';
export 'mobx/nokhte_blur_store.dart';
export 'movies/blur_movie.dart';

class NokhteBlur extends StatelessWidget {
  final NokhteBlurStore store;
  const NokhteBlur({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => CustomAnimationBuilder(
          tween: store.movie,
          control: store.control,
          duration: store.movie.duration,
          onCompleted: () => store.onCompleted(),
          builder: (context, value, child) {
            return Blur(
              colorOpacity: 0.0,
              blur: value.get('blur'),
              child: Container(),
            );
          },
        ),
      );
}
