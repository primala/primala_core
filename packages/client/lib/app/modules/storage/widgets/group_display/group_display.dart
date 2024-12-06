import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_display_store.dart';

class GroupDisplay extends HookWidget {
  final GroupDisplayStore store;

  const GroupDisplay({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();

    useEffect(() {
      store.constructor();
      return null;
    }, []);

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: MultiHitStack(
          children: [
            // Background Grid
            Positioned.fill(
              child: store.groups.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.15,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: store.groups.length,
                        itemBuilder: (context, index) {
                          final group = store.groups[index];
                          return LongPressDraggable<GroupInformationEntity>(
                            data: group,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildGroupItem(group, isDragging: true),
                            ),
                            childWhenDragging: Container(),
                            onDragStarted: () => store.setIsDragging(true),
                            onDragEnd: (_) => store.setIsDragging(false),
                            child: _buildGroupItem(group),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No Groups',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),

            // Dynamic Action Button
            Positioned(
              bottom: 20,
              left: screenSize.width * 0.7,
              right: 0,
              child: Center(
                child: DragTarget<GroupInformationEntity>(
                  builder: (context, candidateData, rejectedData) {
                    return Observer(builder: (context) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: store.isDragging
                            ? _buildDeleteTarget()
                            : _buildAddButton(context),
                      );
                    });
                  },
                  onAcceptWithDetails: (dragTargetDetails) {
                    store.onDragAccepted(dragTargetDetails.data);
                  },
                ),
              ),
            ),
            NokhteBlur(
              store: store.blur,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDeleteTarget() {
    return Container(
      key: const ValueKey('delete-target'),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('add-button'),
      onTap: () {
        store.onTap();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildGroupItem(
    GroupInformationEntity group, {
    bool isDragging = false,
  }) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () => _showGroupDetailsModal(group, context),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDragging
                        ? Colors.red.withOpacity(0.5)
                        : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(80),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  group.groupName.characters.first.toUpperCase(),
                  style: GoogleFonts.jost(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${group.groupName.characters.first.toUpperCase()}${group.groupName.substring(1)}',
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }

  Widget item(String path, String title) => Column(
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
              // color: Colors.white,
            ),
            child: Image.asset(
              path,
              width: 60,
              height: 60,
            ),
          ),
          SizedBox(height: 10),
          Chivo(
            title,
            fontSize: 16,
            fontColor: Colors.white,
          )
        ],
      );

  void _showGroupDetailsModal(
      GroupInformationEntity group, BuildContext context) {
    if (store.showModal) return;
    store.blur.init(end: Seconds.get(0, milli: 200));
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16.0, bottom: 8.0),
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
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Chivo(
                                '${group.groupName.characters.first.toUpperCase()}${group.groupName.substring(1)}',
                                // style: GoogleFonts.jost(
                                fontSize: 30,
                                // fontWeight: FontWeight.bold,
                                // color: Colors.white,
                                // ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Chivo(
                            '@${group.groupName.characters.first.toUpperCase()}${group.groupName.substring(1)}',
                            // style: GoogleFonts.jost(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            // color: Colors.white,
                            // ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            item('assets/storage_icon.png', 'Storage'),
                            item('assets/queue_icon.png', 'Queue'),
                            item('assets/add_remove_icon.png', 'Add or Remove'),
                          ],
                        )
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
      store.blur.reverse();
      store.setShowModal(false);
    });
  }
}
