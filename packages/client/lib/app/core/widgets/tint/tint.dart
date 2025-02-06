// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'movie/tint_movie.dart';
export 'mobx/tint_store.dart';

class Tint extends HookWidget {
  final TintStore store;
  const Tint(
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return CustomAnimationBuilder(
          tween: store.movie,
          control: store.control,
          duration: store.movie.duration,
          builder: (context, value, child) {
            return FullScreen(
              child: Container(
                color: Colors.black.withOpacity(
                  value.get('opacity'),
                ),
              ),
            );
          });
    });
  }
}
