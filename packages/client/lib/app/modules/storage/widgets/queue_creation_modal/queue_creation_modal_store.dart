// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'queue_creation_modal_store.g.dart';

class QueueCreationModalStore = _QueueCreationModalStoreBase
    with _$QueueCreationModalStore;

abstract class _QueueCreationModalStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final NokhteBlurStore blur;
  final GroupDisplaySessionCardStore groupDisplaySessionCard;

  // Text controllers
  TextEditingController queueTitleController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  @observable
  bool isManualSelected = true;

  @observable
  ObservableList<String> queueItems = ObservableList<String>();

  _QueueCreationModalStoreBase({
    required this.blur,
    required this.groupDisplaySessionCard,
  });

  @observable
  bool showModal = false;

  @observable
  int queueSubmissionCount = 0;

  @action
  setShowModal(bool value) => showModal = value;

  @action
  void toggleSelectionMode(bool isManual) {
    isManualSelected = isManual;
  }

  @action
  void addQueueItem() {
    if (itemController.text.trim().isNotEmpty) {
      queueItems.add(itemController.text.trim());
      itemController.clear();
    }
  }

  initReactors() {
    disposers.add(pastSessionMessageReactor());
  }

  pastSessionMessageReactor() =>
      reaction((p0) => groupDisplaySessionCard.currentlySelectedMessage, (p0) {
        queueItems.add(p0.trim());
      });

  @action
  void reorderQueueItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = queueItems.removeAt(oldIndex);
    queueItems.insert(newIndex, item);
  }

  void showGroupDetailsModal(BuildContext context) {
    if (showModal) return;
    blur.init(end: Seconds.get(0, milli: 200));
    initReactors();
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
            NokhteBlur(
              store: blur,
            ),
            SingleChildScrollView(
              controller: scrollController,
              child: Observer(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Queue Title TextField (unchanged)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextField(
                            controller: queueTitleController,
                            style: GoogleFonts.chivo(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w200,
                            ),
                            maxLines: 1,
                            maxLength: 30,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.go,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'QUEUE TITLE',
                              hintStyle: GoogleFonts.chivo(
                                color: Colors.white.withOpacity(.5),
                              ),
                              counterStyle: GoogleFonts.chivo(
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // Selection Buttons (unchanged)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => toggleSelectionMode(true),
                                child: Opacity(
                                  opacity: isManualSelected ? 1.0 : 0.5,
                                  child: Text(
                                    'Manual',
                                    style: GoogleFonts.chivo(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => toggleSelectionMode(false),
                                child: Opacity(
                                  opacity: !isManualSelected ? 1.0 : 0.5,
                                  child: Text(
                                    'Previous',
                                    style: GoogleFonts.chivo(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Conditional Content Based on Selection
                        MultiHitStack(
                          children: [
                            // Manual Mode Content
                            Column(
                              children: [
                                // Item Input TextField (unchanged)
                                if (isManualSelected)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: TextField(
                                      controller: itemController,
                                      style: GoogleFonts.chivo(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w200,
                                      ),
                                      // maxLines: 1,
                                      // maxLength: 30,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      cursorColor: Colors.white,
                                      textInputAction: TextInputAction.go,
                                      textAlign: TextAlign.center,
                                      onSubmitted: (_) => addQueueItem(),
                                      decoration: InputDecoration(
                                        hintText: 'ITEM',
                                        hintStyle: GoogleFonts.chivo(
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                        counterStyle: GoogleFonts.chivo(
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),

                                if (!isManualSelected)
                                  GroupDisplaySessionCard(
                                    showWidget: true,
                                    store: groupDisplaySessionCard,
                                  ),
                                // Text(
                                //   'Past Session Go Here',
                                //   style: GoogleFonts.chivo(
                                //     color: Colors.white.withOpacity(0.7),
                                //     fontSize: 20,
                                //   ),
                                // ),

                                // Divider
                                const Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),

                                // Reorderable List of Queue Items
                                Observer(
                                  builder: (_) => ReorderableListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: queueItems.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        key: ValueKey(queueItems[index]),
                                        title: Text(
                                          queueItems[index],
                                          style: GoogleFonts.chivo(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                    onReorder: reorderQueueItems,
                                  ),
                                ),
                              ],
                            ),

                            // Previous Session Content
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      blur.reverse();
      setShowModal(false);
      dispose();
    });
  }

  // Dispose method to clean up the controllers
  @override
  @action
  void dispose() {
    if (queueTitleController.text.isEmpty || queueItems.isEmpty) return;
    queueSubmissionCount++;
    if (queueSubmissionCount.isEven) {
      queueTitleController.clear();
      itemController.clear();
      queueItems = ObservableList<String>();
    } else {
      super.dispose();
    }

    // queueTitleController.dispose();
    // itemController.dispose();
  }

  // @computed
  // String get queueTitle => queueTitleController.text.isEmpty
  //     ? 'Untitled Queue'
  //     : queueTitleController.text;
}
