import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_modal_store.dart';
export 'widgets/widgets.dart';

class GroupDisplayModal extends HookWidget {
  final GroupDisplaySessionCardStore groupDisplaySessionCard;
  final GroupDisplayQueueCardStore groupDisplayQueueCard;
  final String groupName;
  final String groupHandle;
  final GroupDisplayModalSectionType currentlySelectedSection;
  final Function(GroupDisplayModalSectionType) onSectionTap;
  final Function createQueue;

  const GroupDisplayModal({
    super.key,
    required this.groupName,
    required this.groupDisplaySessionCard,
    required this.groupHandle,
    required this.currentlySelectedSection,
    required this.onSectionTap,
    required this.createQueue,
    required this.groupDisplayQueueCard,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    right: 16.0,
                  ),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.white),
                  ),
                ),
                Chivo(
                  groupName,
                  fontSize: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Chivo(
              groupHandle,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GroupDisplayModalSection(
                type: GroupDisplayModalSectionType.storage,
                isSelected: currentlySelectedSection ==
                    GroupDisplayModalSectionType.storage,
                onTap: onSectionTap,
              ),
              GroupDisplayModalSection(
                type: GroupDisplayModalSectionType.queue,
                isSelected: currentlySelectedSection ==
                    GroupDisplayModalSectionType.queue,
                onTap: (_) {
                  if (!(currentlySelectedSection ==
                      GroupDisplayModalSectionType.queue)) {
                    onSectionTap(_);
                  } else {
                    createQueue();
                  }
                },
              ),
              GroupDisplayModalSection(
                type: GroupDisplayModalSectionType.addRemove,
                isSelected: currentlySelectedSection ==
                    GroupDisplayModalSectionType.addRemove,
                onTap: onSectionTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: MultiHitStack(
              children: [
                GroupDisplaySessionCard(
                  store: groupDisplaySessionCard,
                  showWidget: currentlySelectedSection ==
                      GroupDisplayModalSectionType.storage,
                ),
                GroupDisplayQueueCard(
                  store: groupDisplayQueueCard,
                  showWidget: currentlySelectedSection ==
                      GroupDisplayModalSectionType.queue,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
