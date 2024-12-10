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
      store.constructor(context);
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
                              child: _buildGroupItem(index, group,
                                  isDragging: true),
                            ),
                            childWhenDragging: Container(),
                            onDragStarted: () => store.setIsDragging(true),
                            onDragEnd: (_) => store.setIsDragging(false),
                            child: _buildGroupItem(index, group),
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
              store: store.groupDisplayModal.blur,
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
        store.onAddButtonTap();
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
    int index,
    GroupInformationEntity group, {
    bool isDragging = false,
  }) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () {
          store.setCurrentlySelectedIndex(index);
          store.groupDisplayModal.showGroupDetailsModal(group, context);
        },
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
                  group.groupName.characters.first,
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
              group.groupName,
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
}
