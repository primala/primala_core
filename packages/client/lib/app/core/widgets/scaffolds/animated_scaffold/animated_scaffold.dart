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

class AnimatedScaffold extends HookWidget with OpacityUtils {
  final AnimatedScaffoldStore? store;
  final List<Widget>? children;
  final bool showWidgets;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isScrollable;
  final Widget? body;
  const AnimatedScaffold({
    super.key,
    this.store,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children,
    this.showWidgets = true,
    this.isScrollable = false,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return CustomAnimationBuilder(
        tween: store?.movie ?? MovieTween(),
        duration: store?.movie.duration ?? Duration.zero,
        control: store?.control ?? Control.stop,
        onCompleted: () => store?.onCompleted(),
        builder: (__, value, _) => Scaffold(
          backgroundColor:
              store == null ? NokhteColors.eggshell : value.get('color'),
          resizeToAvoidBottomInset: false,
          body: AnimatedOpacity(
            opacity: useWidgetOpacity(showWidgets),
            duration: Seconds.get(0, milli: 500),
            child: body ??
                (isScrollable
                    ? SingleChildScrollView(child: getBody())
                    : getBody()),
          ),
        ),
      );
    });
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children ?? [],
    );
  }
}
