// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class CenterNokhte extends HookWidget {
  final CenterNokhteStore store;
  const CenterNokhte({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final size = useSquareSize(relativeLength: .20);
    final screenSizeData = useScreenSizeData();
    useEffect(() {
      store.setScreenSize(screenSizeData);
      return null;
    }, []);
    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.topLeft,
            width: size.width,
            height: size.height,
            child: Observer(
              builder: (context) => AnimatedOpacity(
                opacity: useWidgetOpacity(store.showWidget),
                duration: Seconds.get(1),
                child: CustomAnimationBuilder(
                  onCompleted: () => store.onCompleted(),
                  tween: store.movie,
                  duration: store.movie.duration,
                  control: store.control,
                  builder: (context, value, child) => SizedBox.expand(
                    child: CustomPaint(
                      painter: CenterNokhtePainter(
                        radii: value.get('radii'),
                        offsets: Offset(value.get('dx'), value.get('dy')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }
}
