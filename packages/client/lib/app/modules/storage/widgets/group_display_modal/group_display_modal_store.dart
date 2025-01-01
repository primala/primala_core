// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_modal_store.g.dart';

class GroupDisplayModalStore = _GroupDisplayModalStoreBase
    with _$GroupDisplayModalStore;

abstract class _GroupDisplayModalStoreBase extends BaseWidgetStore with Store {
  final GroupDisplaySessionCardStore groupDisplaySessionCard;
  final GroupDisplayQueueCardStore groupDisplayQueueCard;
  final GroupDisplayCollaboratorCardStore groupDisplayCollaboratorCard;
  final NokhteBlurStore blur;
  final QueueCreationModalStore queueCreationModal;

  _GroupDisplayModalStoreBase({
    required this.blur,
    required this.groupDisplaySessionCard,
    required this.groupDisplayQueueCard,
    required this.queueCreationModal,
    required this.groupDisplayCollaboratorCard,
  });

  @observable
  GroupInformationEntity currentlySelectedGroup =
      GroupInformationEntity.empty();

  @action
  setCurrentlySelectedGroup(GroupInformationEntity group) {
    // groupDisplaySessionCard.setSessions(group.sessions);
    groupDisplayCollaboratorCard.setCollaborators(group.collaborators);
    // groupDisplayQueueCard.setQueues(group.queues);
    currentlySelectedGroup = group;
  }

  @observable
  GroupDisplayModalSectionType currentlySelectedSection =
      GroupDisplayModalSectionType.storage;

  @observable
  bool modalIsVisible = false;

  @action
  setCurrentlySelectedSection(GroupDisplayModalSectionType section) =>
      currentlySelectedSection = section;

  @action
  resetValues() {
    currentlySelectedGroup = GroupInformationEntity.empty();
    currentlySelectedSection = GroupDisplayModalSectionType.storage;
  }

  @action
  setModalIsVisible(bool value) => modalIsVisible = value;

  showModal(GroupInformationEntity selectedGroup, BuildContext context) {
    if (modalIsVisible) return;
    setModalIsVisible(true);
    setCurrentlySelectedGroup(selectedGroup);
    blur.init(end: Seconds.get(0, milli: 200));
    showModalBottomSheet(
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(36),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.2),
      context: context,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: .91,
        initialChildSize: .9,
        minChildSize: .7,
        expand: false,
        builder: (context, scrollController) => Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Observer(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: GroupDisplayModal(
                      groupName: currentlySelectedGroup.groupName,
                      groupHandle: currentlySelectedGroup.groupHandle,
                      groupDisplaySessionCard: groupDisplaySessionCard,
                      groupDisplayCollaboratorCard:
                          groupDisplayCollaboratorCard,
                      groupDisplayQueueCard: groupDisplayQueueCard,
                      currentlySelectedSection: currentlySelectedSection,
                      onSectionTap: setCurrentlySelectedSection,
                      createQueue: () {
                        queueCreationModal.setIsCreatingNewQueue(true);
                        queueCreationModal.showModal(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      resetValues();
      blur.reverse();
      setModalIsVisible(false);
    });
  }
}
