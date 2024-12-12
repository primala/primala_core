import 'package:nokhte/app/core/widgets/widgets.dart';

class StorageLists {
  static List<RotatingTextData> get contentSecondary => [
        SharedLists.emptyItem,
        InstructionItems.storageHomeExplanation,
        SharedLists.emptyItem,
      ];

  static List<RotatingTextData> get homeSecondary => [
        SharedLists.emptyItem,
        InstructionItems.homeExplanation,
        SharedLists.emptyItem,
      ];

  static List<RotatingTextData> get homeHeader => [
        RotatingTextData(
          text: "Groups:",
          pauseHere: true,
          mainFontSize: 40.0,
        ),
      ];
}
