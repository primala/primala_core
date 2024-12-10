import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_session_card_store.dart';

class GroupDisplaySessionCard extends HookWidget {
  final GroupDisplaySessionCardStore store;
  final bool showWidget;

  const GroupDisplaySessionCard({
    super.key,
    required this.store,
    required this.showWidget,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: store.sessions.length,
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemBuilder: (context, index) {
        final session = store.sessions[index];

        return Observer(builder: (context) {
          return AnimatedOpacity(
            opacity: useWidgetOpacity(showWidget),
            duration: Seconds.get(0, milli: 500),
            child: GestureDetector(
              onTap: () {
                if (!showWidget) return;
                store.setCurrentlySelectedMessage(session.title);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!showWidget) return;
                          store.toggleExpansion(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            children: [
                              Jost(
                                session.title,
                                fontSize: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (store.expandedStates[index]) ...[
                        const Divider(
                          color: Colors.white24,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: session.content.length,
                            itemBuilder: (context, contentIndex) {
                              return GestureDetector(
                                onTap: () {
                                  if (!showWidget) return;
                                  store.setCurrentlySelectedMessage(
                                    session.content[contentIndex],
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Jost(
                                    session.content[contentIndex],
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
