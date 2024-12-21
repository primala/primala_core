import 'package:nokhte/app/core/widgets/widgets.dart';

class HomeList {
  static List<RotatingTextData> getQrList(String name) => [
        RotatingTextData(
          text: "Scan to add $name",
          onScreenTime: const Duration(seconds: 5),
          // pauseHere: true,
        ),
      ];

  static List<RotatingTextData> get sessionStarterHeader => [
        RotatingTextData(
          text: "Swipe to move",
          pauseHere: true,
          mainFontSize: 20,
        ),
      ];
}
