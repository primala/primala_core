import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/session_information.dart';
export 'group_display_queue_card_store.dart';

class GroupDisplayQueueCard extends HookWidget {
  final GroupDisplayQueueCardStore store;
  final bool showWidget;

  const GroupDisplayQueueCard({
    super.key,
    required this.store,
    required this.showWidget,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;
    final width = useFullScreenSize().width;

    return Observer(builder: (context) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: store.queues.length,
        separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
        itemBuilder: (context, index) {
          final queues = store.queues[index];

          return Observer(builder: (context) {
            return AnimatedOpacity(
              opacity: useWidgetOpacity(showWidget),
              duration: Seconds.get(0, milli: 500),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.04),
                child: showWidget
                    ? Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              spacing: 0,
                              padding: EdgeInsets.zero,
                              onPressed: (_) =>
                                  store.setCurrentlySelectedIndex(index),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever,
                            ),
                          ],
                        ),
                        child:
                            _buildQueueContainer(queues, index, width, height),
                      )
                    : _buildQueueContainer(queues, index, width, height),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildQueueContainer(
      SessionEntity queues, int index, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      width: width * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: !showWidget
                ? null
                : () {
                    store.toggleExpansion(index);
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  Jost(
                    queues.title,
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
            // Padding(
            // padding: const EdgeInsets.all(15.0),
            // child: ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: 0,
            //   itemBuilder: (context, contentIndex) {
            //     return GestureDetector(
            //       onTap: () {
            //         if (!showWidget) return;
            //         // store.setCurrentlySelectedMessage(
            //           // queues.content[contentIndex],
            //         // );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 5.0),
            //         child: Jost(
            //           queues.content[contentIndex],
            //           fontSize: 18,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ),
          ],
        ],
      ),
    );
  }
}
