import 'package:nokhte/app/core/widgets/widgets.dart';

class HomeList {
  static List<RotatingTextData> get list => [
        RotatingTextData(
          text: "Tap on the compass to navigate",
          onScreenTime: const Duration(seconds: 5),
          // pauseHere: true,
        ),
        RotatingTextData(
          text: "Double tap to enter solo session",
          onScreenTime: const Duration(seconds: 5),
        ),
        SharedLists.emptyItem,
        RotatingTextData(
          text: "Swipe to move",
          pauseHere: true,
          mainFontSize: 20,
        ),
        SharedLists.emptyItem,
      ];
  static List<RotatingTextData> get gestureCrossList => [
        RotatingTextData(
          text: "Swipe to move",
          pauseHere: true,
          mainFontSize: 20,
        ),
      ];
}
