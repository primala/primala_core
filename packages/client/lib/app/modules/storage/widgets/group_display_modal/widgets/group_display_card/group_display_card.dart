import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:nokhte_backend/tables/sessions.dart';
export 'group_display_card_store.dart';

class GroupDisplayCard extends HookWidget {
  final GroupDisplayCardStore store;
  final bool showWidget;

  const GroupDisplayCard({
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
        itemCount: store.sessions.length,
        separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
        itemBuilder: (context, index) {
          return Observer(builder: (context) {
            final sessions = store.sessions[index];
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
                              onPressed: (_) => store.setSessionUIDToDelete(
                                  store.sessions[index].uid),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever,
                            ),
                          ],
                        ),
                        child: _buildQueueContainer(
                            sessions, index, width, height),
                      )
                    : _buildQueueContainer(sessions, index, width, height),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildQueueContainer(
      SessionEntity sessions, int index, double width, double height) {
    return GestureDetector(
      onTap: !showWidget
          ? null
          : () {
              store.setSessionUIDToOpen(store.sessions[index].uid);
            },
      child: Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  Jost(
                    sessions.title,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
