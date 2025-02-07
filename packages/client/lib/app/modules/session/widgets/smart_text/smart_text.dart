import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
export 'smart_text_store.dart';

class SmartText extends HookWidget {
  final String content;
  final SmartTextStore store;

  const SmartText(this.content, this.store, {super.key});
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(0, milli: 500),
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Jost(
              content,
              fontSize: 18,
            ),
          ),
        ),
      );
    });
  }
}
