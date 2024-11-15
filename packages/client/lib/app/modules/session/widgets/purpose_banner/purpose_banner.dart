import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'purpose_banner.dart';
export 'purpose_banner.dart';
export 'purpose_banner_store.dart';

class PurposeBanner extends HookWidget {
  final PurposeBannerStore store;
  const PurposeBanner({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => AnimatedOpacity(
            opacity: useWidgetOpacity(store.showWidget),
            duration: Seconds.get(0, milli: 500),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Jost(
                      store.purpose,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )));
  }
}
