import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_modal_store.dart';
export 'widgets/widgets.dart';

class GroupDisplayModal extends HookWidget {
  final GroupDisplayModalStore store;

  const GroupDisplayModal({
    super.key,
    required this.store,
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
                  store.currentlySelectedGroup.groupName,
                  fontSize: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Chivo(
              store.currentlySelectedGroup.groupHandle,
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
                isSelected: store.currentlySelectedSection ==
                    GroupDisplayModalSectionType.storage,
                onTap: store.setCurrentlySelectedSection,
              ),
              GroupDisplayModalSection(
                type: GroupDisplayModalSectionType.queue,
                isSelected: store.currentlySelectedSection ==
                    GroupDisplayModalSectionType.queue,
                onTap: store.setCurrentlySelectedSection,
              ),
              GroupDisplayModalSection(
                type: GroupDisplayModalSectionType.addRemove,
                isSelected: store.currentlySelectedSection ==
                    GroupDisplayModalSectionType.addRemove,
                onTap: store.setCurrentlySelectedSection,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: MultiHitStack(
              children: [
                GroupDisplaySessionCard(
                  store: store.groupDisplaySessionCard,
                  showWidget: store.currentlySelectedSection ==
                      GroupDisplayModalSectionType.storage,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
