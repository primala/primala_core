import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class Tap extends HookWidget {
  final TapDetector store;
  final Widget child;
  const Tap({
    super.key,
    required this.store,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;
    useEffect(() {
      store.setScreenHeight(height);
      return null;
    }, []);
    return GestureDetector(
      onTap: () => store.onTap(),
      onDoubleTap: () => store.onDoubleTap(),
      onTapDown: (details) => store.onTapDown(details.globalPosition),
      child: child,
    );
  }
}
