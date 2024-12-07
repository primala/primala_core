import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_modal_store.dart';
export 'group_display_modal_section.dart';

class GroupDisplayModal extends HookWidget {
  final GroupDisplayModalStore store;

  const GroupDisplayModal({
    super.key,
    required this.store,
  });

  static const Map<GroupDisplayModalSection, Map<String, dynamic>>
      sectionDetails = {
    GroupDisplayModalSection.storage: {
      'asset': 'assets/storage_icon.png',
      'title': 'Storage',
      'content':
          'Storage Section Content: View and manage your stored files and documents.',
    },
    GroupDisplayModalSection.queue: {
      'asset': 'assets/queue_icon.png',
      'title': 'Queue',
      'content':
          'Queue Section Content: Track and organize your pending tasks and items.',
    },
    GroupDisplayModalSection.addRemove: {
      'asset': 'assets/add_remove_icon.png',
      'title': 'Add or Remove',
      'content':
          'Add or Remove Section Content: Modify group members and manage access.',
    },
  };

  Widget sectionIcon(GroupDisplayModalSection section) {
    final details = sectionDetails[section]!;
    final isSelected = store.currentlySelectedSection == section;

    return GestureDetector(
      onTap: () {
        store.setCurrentlySelectedSection(section);
      },
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.5,
        duration: Seconds.get(1),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                details['asset']!,
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(height: 10),
            Chivo(
              details['title']!,
              fontSize: 16,
              fontColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget sectionContent(GroupDisplayModalSection section) {
    final details = sectionDetails[section]!;
    final isSelected = store.currentlySelectedSection == section;

    return AnimatedOpacity(
      opacity: isSelected ? 1.0 : 0.0,
      duration: Seconds.get(1),
      child: Chivo(
        details['content']!,
        fontSize: 18,
        fontColor: Colors.white,
        shouldCenter: true,
      ),
    );
  }

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
              sectionIcon(GroupDisplayModalSection.storage),
              sectionIcon(GroupDisplayModalSection.queue),
              sectionIcon(GroupDisplayModalSection.addRemove),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: MultiHitStack(
              children: [
                sectionContent(GroupDisplayModalSection.queue),
                sectionContent(GroupDisplayModalSection.addRemove),
                sectionContent(GroupDisplayModalSection.storage),
              ],
            ),
          ),
        ],
      );
    });
  }
}
