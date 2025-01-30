// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'movies.dart';
export 'animated_scaffold_store.dart';

class AnimatedScaffold extends HookWidget {
  final AnimatedScaffoldStore? store;
  final Widget child;
  final bool showWidgets;
  const AnimatedScaffold({
    super.key,
    this.store,
    required this.child,
    this.showWidgets = true,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => CustomAnimationBuilder(
              tween: store?.movie ?? MovieTween(),
              duration: store?.movie.duration ?? Duration.zero,
              control: store?.control ?? Control.stop,
              onCompleted: () => store?.onCompleted(),
              builder: (context, value, _) => Scaffold(
                backgroundColor:
                    store == null ? NokhteColors.eggshell : value.get('color'),
                // backgroundColor: Colors.red,
                resizeToAvoidBottomInset: false,
                body: Observer(builder: (context) {
                  return AnimatedOpacity(
                      opacity: useWidgetOpacity(showWidgets),
                      duration: Seconds.get(0, milli: 500),
                      child: child);
                }),
              ),
            ));
  }
}
