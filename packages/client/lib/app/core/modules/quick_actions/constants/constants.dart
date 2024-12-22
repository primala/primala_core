import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nokhte/app/core/modules/hive/hive.dart';
import 'package:nokhte/app/core/modules/quick_actions/quick_actions.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsConstants {
  static List<ShortcutItem> shortcutItems = [
    ShortcutItem(
      type: QuickActionsEnum.viewStorage.toString(),
      localizedTitle: 'View Storage',
      icon: 'doc',
    ),
  ];

  static initQuickActions() async {
    QuickActions quickActions = const QuickActions();
    await quickActions.setShortcutItems(QuickActionsConstants.shortcutItems);
    await Hive.openBox(HiveBoxes.userInformation.toString());
  }

  static String getRoute(String shortcutType) {
    final viewStorage = QuickActionsEnum.viewStorage.toString();
    if (shortcutType == viewStorage) {
      return StorageConstants.home;
    } else {
      return '';
    }
  }

  static route(Function onRoute) {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      onRoute();
      Modular.to.navigate(HomeConstants.quickActionsRouter, arguments: {
        HomeConstants.QUICK_ACTIONS_ROUTE: getRoute(shortcutType),
      });
    });
  }
}
// }
