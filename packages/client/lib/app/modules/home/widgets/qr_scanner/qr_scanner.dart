import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
export 'qr_scanner_store.dart';
import 'canvas/qr_scanner_overlay_painter.dart';
import 'qr_scanner.dart';

class QrScanner extends HookWidget {
  final QrScannerStore store;

  const QrScanner({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.constructor();
      return () async => await store.deconstructor();
    }, []);

    final screenSize = useFullScreenSize();
    final cutOutSize = screenSize.width * .35;

    return Observer(builder: (context) {
      return AnimatedOpacity(
        duration: Seconds.get(1),
        opacity: useWidgetOpacity(store.showWidget),
        child: FullScreen(
          child: Stack(
            children: [
              FullScreen(
                child: MobileScanner(
                  fit: BoxFit.cover,
                  controller: store.controller,
                  scanWindow: Rect.largest,
                ),
              ),
              CustomAnimationBuilder(
                tween: store.movie,
                control: store.control,
                duration: store.movie.duration,
                builder: (context, value, child) {
                  return FullScreen(
                    child: CustomPaint(
                      painter: ScannerOverlay(
                          opacity: value.get('o'), cutoutSize: cutOutSize),
                    ),
                  );
                },
              ),
              Center(
                child: SmartText(
                  topPadding: .38,
                  topBump: .004,
                  store: store.smartText,
                  opacityDuration: Seconds.get(1),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
