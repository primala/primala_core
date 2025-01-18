// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'movies.dart';
export 'animated_scaffold_store.dart';

class AnimatedScaffold extends HookWidget {
  final AnimatedScaffoldStore store;
  final Widget child;
  const AnimatedScaffold({
    super.key,
    required this.store,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => CustomAnimationBuilder(
              tween: store.movie,
              duration: store.movie.duration,
              control: store.control,
              onCompleted: () => store.onCompleted(),
              builder: (context, value, _) => Scaffold(
                backgroundColor: value.get('color'),
                // backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: child,
              ),
            ));
  }
}
