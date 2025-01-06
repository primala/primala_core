import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'settings_layout_store.dart';

class SettingsLayout extends HookWidget {
  final SettingsLayoutStore store;
  const SettingsLayout({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.16,
              ),
              child: Image.asset(
                'assets/groups/user_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            Jost(
              store.fullName,
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ExpansionTile(
              title: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: const Jost(
                  'Deactivate Account',
                  fontSize: 18,
                ),
              ),
              backgroundColor: Colors.transparent,
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              trailing: Icon(
                store.isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.chevron_right,
                color: Colors.white,
              ),
              onExpansionChanged: (expanded) {
                store.setIsExpanded(expanded);
              },
              expandedAlignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: TextButton(
                    onPressed: () {
                      store.onTap();
                    },
                    child: const Jost(
                      'Yes',
                      fontSize: 20,
                      fontColor: Color(0xFFFF6F6F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
