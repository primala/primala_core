import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widget_constants.dart';

class MessagesData {
  static List<RotatingTextData> get loginList => [
        RotatingTextData(
          initialFadeInDelay: Seconds.get(1),
          mainMessage: "Howdy",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "The Point Of The App Is",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "To Collectively Uplift Ideas Into Reality",
          onScreenTime: Seconds.get(2),
        ),
        RotatingTextData(
          initialFadeInDelay: Seconds.get(2),
          mainMessage: "Tap",
          unlockGesture: Gestures.tap,
          pauseHere: true,
          onScreenTime: Seconds.get(2),
        ),
      ];
}
