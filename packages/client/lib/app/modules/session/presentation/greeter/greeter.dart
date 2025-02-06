import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class GreeterScreen extends HookWidget {
  const GreeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: 0,
    );

    final fadeIn = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(controller),
    );

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    handleTap() async {
      await controller.reverse();

      Timer(Seconds.get(0, milli: 500), () {
        Modular.to.navigate(SessionConstants.mainScreen);
      });
    }

    return AnimatedScaffold(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: handleTap,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: fadeIn,
                child: const Jost(
                  'Put your phone on do not disturb',
                  fontSize: 32,
                  // fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
