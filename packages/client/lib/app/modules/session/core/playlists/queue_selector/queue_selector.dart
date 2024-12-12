import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'queue_selector_store.dart';

class QueueSelector extends HookWidget {
  final QueueSelectorStore store;

  const QueueSelector({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.setWidgetVisibility(false);
      return null;
    }, []);

    final height = useFullScreenSize().height;

    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(top: height * 0.17),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: store.groups.length,
          separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
          itemBuilder: (context, index) {
            final group = store.groups[index];

            return Observer(
              builder: (context) {
                return AnimatedOpacity(
                  opacity: useWidgetOpacity(store.showWidget),
                  duration: Seconds.get(0, milli: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: height * 0.04),
                    child: GestureDetector(
                      onDoubleTap: store.showWidget
                          ? () {
                              store.selectGroup(group);
                              // onQueueSelected?.call(group, QueueEntity.empty());
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: store.selectedGroup == group
                                ? Colors.red
                                : Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: !store.showWidget
                                  ? null
                                  : () {
                                      store.toggleGroupExpansion(group);
                                    },
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Jost(
                                    group.groupName,
                                    fontSize: 20,
                                    shouldCenter: true,
                                    fontColor: store.selectedGroup == group
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (store.expandedGroups.contains(group) &&
                                group.queues.isNotEmpty) ...[
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
                                  itemCount: group.queues.length,
                                  itemBuilder: (context, queueIndex) {
                                    return Observer(builder: (context) {
                                      final queue = group.queues[queueIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          if (!store.showWidget) return;
                                          store.selectQueue(queue);
                                          Timer(Seconds.get(1), () {
                                            store.selectGroup(group);
                                          });
                                          // onQueueSelected?.call(group, queue);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: store.selectedQueue == queue
                                                ? Colors.white10
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Jost(
                                              queue.title,
                                              fontSize: 18,
                                              fontColor:
                                                  store.selectedQueue == queue
                                                      ? Colors.blue
                                                      : Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                            // Show placeholder if no queues
                            if (group.queues.isEmpty &&
                                store.expandedGroups.contains(group)) ...[
                              const Divider(
                                color: Colors.white24,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: const Center(
                                  child: Jost(
                                    'No queues created',
                                    fontSize: 16,
                                    fontColor: Colors.white54,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
