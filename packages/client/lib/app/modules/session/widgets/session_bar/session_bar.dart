import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'session_bar_store.dart';

class SessionBar extends HookWidget {
  final SessionBarStore store;
  final Function onDocTapped;
  final Function onPauseTapped;
  const SessionBar(
    this.store, {
    super.key,
    required this.onDocTapped,
    required this.onPauseTapped,
  });

  @override
  Widget build(BuildContext context) {
    final size = useScaledSize(
      baseValue: .07,
      screenSize: useFullScreenSize(),
      bumpPerHundredth: 0.0001,
    );
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(0, milli: 500),
        child: Padding(
          padding: EdgeInsets.only(top: size),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: store.showWidget ? () => onDocTapped() : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/groups/storage_icon.png',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: store.showWidget ? () => onPauseTapped() : null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/session/pause_icon.png',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
