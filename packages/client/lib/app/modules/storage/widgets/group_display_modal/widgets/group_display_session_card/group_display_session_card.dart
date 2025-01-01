import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    final width = useFullScreenSize().width;

    return Observer(builder: (context) {
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
                onTap: !showWidget
                    ? null
                    : () {
                        store.setCurrentlySelectedIndex(index);
                      },
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
                          child: _buildSessionContainer(
                              session, index, width, height),
                        )
                      : _buildSessionContainer(session, index, width, height),
                ),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildSessionContainer(
      dynamic session, int index, double width, double height) {
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
                    store.setCurrentlySelectedIndex(index);
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
        ],
      ),
    );
  }
}
